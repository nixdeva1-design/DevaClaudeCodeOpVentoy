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

{
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
  networking.networkmanager.enable = true;  # WiFi via GUI/nmcli

  # ---------------------------------------------------------------------------
  # Tijdzone en taal
  # ---------------------------------------------------------------------------
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "nl_NL.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ALL = "nl_NL.UTF-8";
  };
  console.keyMap = "nl";                    # Nederlands toetsenbord

  # ---------------------------------------------------------------------------
  # Grafische omgeving (XFCE — lichtgewicht, werkt op oude hardware)
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
  # Gebruiker — pas "deva" aan naar jouw naam als gewenst
  # ---------------------------------------------------------------------------
  users.users.deva = {
    isNormalUser = true;
    description = "Deva";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    shell = pkgs.bash;
    # Wachtwoord instellen via: passwd deva
  };

  # wheel groep mag sudo gebruiken
  security.sudo.wheelNeedsPassword = true;

  # ---------------------------------------------------------------------------
  # Programma's — alles wat je nodig hebt
  # ---------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    # Terminal en basis tools
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
    python3Packages.pip

    # Browser
    firefox

    # Teksteditor met GUI
    gedit

    # Netwerk tools
    networkmanagerapplet   # WiFi in taakbalk
    openssh

    # Ontwikkeling
    gcc
    gnumake
    docker-compose
  ];

  # ---------------------------------------------------------------------------
  # Claude Code
  # Installeer als npm global package na eerste boot:
  #   npm install -g @anthropic-ai/claude-code
  # ---------------------------------------------------------------------------
  # API key instellen (vervang met jouw sleutel):
  #   echo 'export ANTHROPIC_API_KEY=sk-ant-...' >> ~/.bashrc

  # ---------------------------------------------------------------------------
  # PostgreSQL database
  # ---------------------------------------------------------------------------
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    ensureDatabases = [ "gitea" ];
    ensureUsers = [
      {
        name = "gitea";
        ensureDBOwnership = true;
      }
    ];
    authentication = ''
      local all all trust
      host  all all 127.0.0.1/32 trust
    '';
  };

  # ---------------------------------------------------------------------------
  # Gitea — eigen Git server
  # Bereikbaar via: http://localhost:3000
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
    settings = {
      server = {
        HTTP_PORT = 3000;
        DOMAIN = "localhost";
        ROOT_URL = "http://localhost:3000/";
      };
      service = {
        DISABLE_REGISTRATION = false;  # Na eerste gebruiker op true zetten
      };
    };
  };

  # ---------------------------------------------------------------------------
  # SSH server (voor toegang tot andere computers)
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
    allowedTCPPorts = [
      22    # SSH
      3000  # Gitea
    ];
  };

  # ---------------------------------------------------------------------------
  # Automatisch inloggen (handig voor USB gebruik)
  # Verwijder deze regels als je wachtwoord bij opstarten wilt
  # ---------------------------------------------------------------------------
  services.displayManager.autoLogin = {
    enable = true;
    user = "deva";
  };

  # ---------------------------------------------------------------------------
  # NixOS versie — niet aanpassen
  # ---------------------------------------------------------------------------
  system.stateVersion = "24.11";
}
