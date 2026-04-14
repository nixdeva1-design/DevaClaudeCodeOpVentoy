{
  description = "DevaClaudeCode op Ventoy - NixOS configuratie met king-disk CLI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    unstable = import nixpkgs-unstable { inherit system; };

    # king-disk CLI pakket
    king-disk = pkgs.writeShellScriptBin "king-disk"
      (builtins.readFile ./bin/king-disk);

  in {
    # NixOS systeemconfiguratie voor Ventoy USB opstartomgeving
    nixosConfigurations.ventoy = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        # King-disk module
        ./modules/king-disk.nix

        # Hoofdconfiguratie
        ({ config, pkgs, ... }: {
          # King-disk inschakelen
          services.kingDisk = {
            enable = true;
            label = "KING";
            autoMount = false;
          };

          # Basis systeeminstellingen
          system.stateVersion = "24.11";

          # Bootloader (voor Ventoy: GRUB in EFI modus)
          boot.loader.grub.enable = true;
          boot.loader.grub.efiSupport = true;
          boot.loader.grub.efiInstallAsRemovable = true;
          boot.loader.efi.efiSysMountPoint = "/boot/efi";

          # Netwerk
          networking.networkmanager.enable = true;
          networking.hostName = "nixos-ventoy";

          # Desktop omgeving (Xfce - lichtgewicht zoals Xubuntu)
          services.xserver = {
            enable = true;
            desktopManager.xfce.enable = true;
            displayManager.lightdm.enable = true;
          };

          # Essentieel: Firefox en andere pakketten
          environment.systemPackages = with pkgs; [
            # Browser
            firefox

            # Terminal gereedschap
            king-disk
            git
            vim
            wget
            curl

            # Schijfbeheer
            gparted
            parted
            util-linux
            ntfs3g      # NTFS ondersteuning (voor Ventoy schijven)
            dosfstools  # FAT32 ondersteuning
            exfatprogs  # exFAT ondersteuning

            # Systeem info
            htop
            lsof
            pciutils
            usbutils

            # Bestandsbeheer
            xfce.thunar
            xfce.thunar-volman
          ];

          # Nederlandse taalinstellingen
          i18n.defaultLocale = "nl_NL.UTF-8";
          console.keyMap = "nl";
          services.xserver.xkb.layout = "nl";

          # Tijdzone
          time.timeZone = "Europe/Amsterdam";

          # Standaard gebruiker
          users.users.deva = {
            isNormalUser = true;
            extraGroups = [ "wheel" "networkmanager" "disk" "plugdev" ];
            initialPassword = "deva";
          };

          # sudo zonder wachtwoord voor wheel groep
          security.sudo.wheelNeedsPassword = false;

          # USB en hotplug ondersteuning
          services.udisks2.enable = true;
          services.udev.enable = true;

          # NTFS en exFAT kernel modules
          boot.supportedFilesystems = [ "ntfs" "exfat" "vfat" "ext4" "btrfs" ];

          # Automount via udev (optioneel)
          hardware.pulseaudio.enable = true;
        })
      ];
    };

    # Standalone pakket om king-disk te installeren
    packages.${system} = {
      default = king-disk;
      inherit king-disk;
    };

    # DevShell om king-disk lokaal te testen
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        king-disk
        pkgs.util-linux   # lsblk, fdisk
        pkgs.parted
      ];

      shellHook = ''
        echo "=== King Disk Development Shell ==="
        echo "Gebruik: king-disk --help"
        echo ""
      '';
    };
  };
}
