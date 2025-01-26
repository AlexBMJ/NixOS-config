{ pkgs, lib, config, ... }:
with lib;
let
  module_name = "mullvad";
  cfg = config.configured.programs."${module_name}";
in {
  options.configured.programs."${module_name}" = {
    enable = mkEnableOption "Enable Mullvad VPN Client";
  };

  config = mkIf cfg.enable {
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };
}


