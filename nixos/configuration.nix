# =============================================================================
# configuration.nix — NixOS USB Werkplek
# DevaClaudeCodeOpVentoy
#
# Dit bestand beschrijft het HELE systeem.
# Als je ooit opnieuw moet installeren: dit bestand kopiëren is genoeg.
#
# Bewerken: sudo nano /etc/nixos/configuration.nix
# Toepassen: sudo nixos-rebuild switch
# =============================================================================

{ config, pkgs, ... }:

let
  # king-disk: CLI om de king schijf (Ventoy USB) te detecteren en te beheren
  king-disk = pkgs.writeShellScriptBin "king-disk" ''
    #!/usr/bin/env bash
    set -euo pipefail

    VERSION="1.0.0"
    KING_CONF="$HOME/.king-disk"

    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    CYAN='\033[0;36m'
    BOLD='\033[1m'
    R='\033[0m'

    usage() {
      echo -e "''${BOLD}king-disk v$VERSION''${R} — NixOS king schijf CLI"
      echo ""
      echo -e "''${BOLD}GEBRUIK:''${R}  king-disk <commando>"
      echo ""
      echo "  status        Toon king schijf status"
      echo "  list          Lijst alle schijven"
      echo "  find          Detecteer king schijf automatisch"
      echo "  set <schijf>  Stel king schijf in (bijv. /dev/sdb)"
      echo "  mount         Koppel king schijf aan /mnt/king"
      echo "  umount        Ontkoppel king schijf"
      echo "  where         Geef pad van king schijf"
      echo "  shell         Open shell in /mnt/king"
      echo ""
      echo -e "''${BOLD}VOORBEELD:''${R}"
      echo "  king-disk find"
      echo "  king-disk mount && cd /mnt/king"
    }

    get_king() {
      [[ -f "$KING_CONF" ]] && cat "$KING_CONF" || echo ""
    }

    save_king() {
      echo "$1" > "$KING_CONF"
      echo -e "''${GREEN}King schijf opgeslagen:''${R} $1"
    }

    cmd_status() {
      local king; king=$(get_king)
      echo -e "''${BOLD}''${CYAN}=== King Schijf Status ===''${R}"
      if [[ -z "$king" ]]; then
        echo -e "''${YELLOW}Niet ingesteld.''${R} Gebruik: king-disk find"
      elif [[ -b "$king" ]]; then
        echo -e "''${GREEN}Schijf:''${R} $king"
        lsblk -o NAME,SIZE,TYPE,FSTYPE,LABEL,MOUNTPOINT "$king" 2>/dev/null || true
        mountpoint -q /mnt/king 2>/dev/null \
          && echo -e "''${GREEN}Gekoppeld op:''${R} /mnt/king" \
          || echo -e "''${YELLOW}Niet gekoppeld''${R} — gebruik: king-disk mount"
      else
        echo -e "''${RED}Schijf niet beschikbaar:''${R} $king"
      fi
    }

    cmd_list() {
      echo -e "''${BOLD}''${CYAN}=== Schijven ===''${R}"
      lsblk -o NAME,SIZE,TYPE,FSTYPE,LABEL,MOUNTPOINT 2>/dev/null
      local king; king=$(get_king)
      [[ -n "$king" ]] && echo -e "\n''${GREEN}King:''${R} $king"
    }

    cmd_find() {
      echo -e "''${BOLD}''${CYAN}=== Detectie ===''${R}"
      local found=""

      # 1. Label KING
      if [[ -e /dev/disk/by-label/KING ]]; then
        found=$(readlink -f /dev/disk/by-label/KING)
        echo -e "''${GREEN}Gevonden via label KING:''${R} $found"
        save_king "$found"; return 0
      fi

      # 2. Ventoy partitie
      for lbl in ventoy VTOYEFI Ventoy; do
        if [[ -e "/dev/disk/by-label/$lbl" ]]; then
          found=$(readlink -f "/dev/disk/by-label/$lbl")
          found=$(echo "$found" | sed 's/[0-9]*$//')
          echo -e "''${GREEN}Ventoy schijf gevonden:''${R} $found"
          save_king "$found"; return 0
        fi
      done

      # 3. Eerste USB schijf
      found=$(lsblk -d -o NAME,TRAN 2>/dev/null | awk '$2=="usb"{print "/dev/"$1}' | head -1)
      if [[ -n "$found" ]]; then
        echo -e "''${GREEN}USB schijf gevonden:''${R} $found"
        save_king "$found"; return 0
      fi

      echo -e "''${RED}Geen king schijf gevonden.''${R}"
      echo "Gebruik: king-disk set /dev/sdX"
      exit 1
    }

    cmd_set() {
      local disk="''${1:-}"
      [[ -z "$disk" ]] && { echo -e "''${RED}Geef een schijf op.''${R}"; exit 1; }
      [[ ! -b "$disk" ]] && { echo -e "''${RED}Geen geldig apparaat:''${R} $disk"; exit 1; }
      save_king "$disk"
    }

    cmd_mount() {
      local king; king=$(get_king)
      [[ -z "$king" ]] && { echo -e "''${RED}Geen king schijf ingesteld.''${R}"; exit 1; }
      mountpoint -q /mnt/king 2>/dev/null && { echo "Al gekoppeld op /mnt/king"; return 0; }
      [[ $EUID -ne 0 ]] && SUDO=sudo || SUDO=""
      $SUDO mkdir -p /mnt/king
      $SUDO mount "$king" /mnt/king
      echo -e "''${GREEN}Gekoppeld op /mnt/king''${R}"
    }

    cmd_umount() {
      mountpoint -q /mnt/king 2>/dev/null || { echo "Niet gekoppeld."; return 0; }
      [[ $EUID -ne 0 ]] && sudo umount /mnt/king || umount /mnt/king
      echo -e "''${GREEN}Ontkoppeld.''${R}"
    }

    cmd_where() {
      local king; king=$(get_king)
      [[ -z "$king" ]] && { echo -e "''${YELLOW}Niet ingesteld.''${R}" >&2; exit 1; }
      echo "$king"
    }

    cmd_shell() {
      mountpoint -q /mnt/king 2>/dev/null || cmd_mount
      cd /mnt/king
      echo -e "''${GREEN}Shell in /mnt/king — typ exit om terug te gaan''${R}"
      PS1="[king:/mnt/king]\$ " ''${SHELL:-bash} --norc
    }

    case "''${1:-status}" in
      status)        cmd_status ;;
      list)          cmd_list ;;
      find)          cmd_find ;;
      set)           shift; cmd_set "$@" ;;
      mount)         cmd_mount ;;
      umount|unmount) cmd_umount ;;
      where)         cmd_where ;;
      shell)         cmd_shell ;;
      help|--help|-h) usage ;;
      --version|-v)  echo "king-disk v$VERSION" ;;
      *) echo -e "''${RED}Onbekend commando:''${R} $1"; usage; exit 1 ;;
    esac
  '';

in {
  imports = [
    ./hardware-configuration.nix   # Automatisch gegenereerd, niet aanpassen
  ];

  # ---------------------------------------------------------------------------
  # Opstarten (bootloader)
  # ---------------------------------------------------------------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Werkt op zoveel mogelijk computers (USB portabiliteit)
  boot.kernelParams = [ "nomodeset" ];
  hardware.enableRedistributableFirmware = true;

  # ---------------------------------------------------------------------------
  # Netwerk
  # ---------------------------------------------------------------------------
  networking.hostName = "deva-usb";
  networking.networkmanager.enable = true;

  # ---------------------------------------------------------------------------
  # Tijdzone en taal
  # ---------------------------------------------------------------------------
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "nl_NL.UTF-8";
  i18n.extraLocaleSettings.LC_ALL = "nl_NL.UTF-8";
  console.keyMap = "nl";

  # ---------------------------------------------------------------------------
  # Grafische omgeving (XFCE)
  # ---------------------------------------------------------------------------
  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.xkb.layout = "nl";

  # ---------------------------------------------------------------------------
  # Geluid
  # ---------------------------------------------------------------------------
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # ---------------------------------------------------------------------------
  # Gebruiker
  # ---------------------------------------------------------------------------
  users.users.deva = {
    isNormalUser = true;
    description = "Deva";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "disk" ];
    shell = pkgs.bash;
  };

  security.sudo.wheelNeedsPassword = true;

  # ---------------------------------------------------------------------------
  # Programma's
  # ---------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    # king-disk CLI — detecteer en beheer de king schijf
    king-disk

    # Terminal en basis
    bash
    git
    curl
    wget
    nano
    htop
    unzip
    zip

    # Node.js (voor Claude Code)
    nodejs_22
    nodePackages.npm

    # Python
    python3

    # Browser
    firefox

    # Teksteditor
    gedit

    # Netwerk
    networkmanagerapplet
    openssh

    # Schijfbeheer
    util-linux   # lsblk, fdisk
    parted
    gparted
    ntfs3g
    dosfstools
    exfatprogs

    # Ontwikkeling
    gcc
    gnumake
  ];

  # ---------------------------------------------------------------------------
  # PostgreSQL
  # ---------------------------------------------------------------------------
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    ensureDatabases = [ "gitea" ];
    ensureUsers = [{ name = "gitea"; ensureDBOwnership = true; }];
    authentication = ''
      local all all trust
      host  all all 127.0.0.1/32 trust
    '';
  };

  # ---------------------------------------------------------------------------
  # Gitea
  # ---------------------------------------------------------------------------
  services.gitea = {
    enable = true;
    database = {
      type = "postgres";
      host = "127.0.0.1";
      port = 5432;
      name = "gitea";
      user = "gitea";
    };
    settings.server = {
      HTTP_PORT = 3000;
      DOMAIN = "localhost";
      ROOT_URL = "http://localhost:3000/";
    };
  };

  # ---------------------------------------------------------------------------
  # SSH
  # ---------------------------------------------------------------------------
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  # ---------------------------------------------------------------------------
  # Firewall
  # ---------------------------------------------------------------------------
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 3000 ];
  };

  # ---------------------------------------------------------------------------
  # Automatisch inloggen
  # ---------------------------------------------------------------------------
  services.displayManager.autoLogin = {
    enable = true;
    user = "deva";
  };

  # ---------------------------------------------------------------------------
  # USB en schijf ondersteuning
  # ---------------------------------------------------------------------------
  services.udisks2.enable = true;
  boot.supportedFilesystems = [ "ntfs" "exfat" "vfat" "ext4" "btrfs" ];

  system.stateVersion = "24.11";
}
