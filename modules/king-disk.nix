# king-disk NixOS module
# Maakt de king-disk CLI tool beschikbaar als NixOS systeempakket
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kingDisk;

  king-disk-script = pkgs.writeShellScriptBin "king-disk" (builtins.readFile ../bin/king-disk);

in {
  options.services.kingDisk = {
    enable = mkEnableOption "king-disk schijf beheer CLI";

    label = mkOption {
      type = types.str;
      default = "KING";
      description = "Schijflabel om automatisch te detecteren als king schijf";
    };

    autoMount = mkOption {
      type = types.bool;
      default = false;
      description = "King schijf automatisch koppelen bij opstarten";
    };

    mountPoint = mkOption {
      type = types.str;
      default = "/mnt/king";
      description = "Koppelpunt voor de king schijf";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ king-disk-script ];

    environment.variables = {
      KING_LABEL = cfg.label;
    };

    # Optioneel: automatisch koppelen
    systemd.services.king-disk-mount = mkIf cfg.autoMount {
      description = "King schijf automatisch koppelen";
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${king-disk-script}/bin/king-disk mount";
        ExecStop = "${king-disk-script}/bin/king-disk umount";
      };
    };
  };
}
