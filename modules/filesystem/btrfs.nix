{ lib, config, ... }:
let
  module_name = "btrfs";
  cfg = config.filesystem."${module_name}";
  inherit (lib) mkEnableOption mkIf;
in {
  options.filesystem."${module_name}" = {
    enable = mkEnableOption "Set system up for BTRFS";
  };

  config = mkIf cfg.enable {
    boot.supportedFilesystems = [ "btrfs" ];
    services.btrfs.autoScrub.enable = true;
  };
}

