{ config, username, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/disko/btrfs.nix
    ../../modules/hardware/gpu/amd.nix
  ];

  filesystem.btrfs.enable = true;

  # Users
  age.secrets."${username}-password".file = ../../secrets/${username}-password.age;
  users.users.${username}.hashedPasswordFile = config.age.secrets."${username}-password".path;

  # Home Manager
  home-manager.users.${username} = {
    imports = [
      ./home.nix
    ];
  };

  # Desktop Environment
  desktops.hyprland.enable = true;
  desktops.hyprland.extraConfig = ''
    monitor=DP-1,2560x1440@60,0x0,1
    monitor=DP-2,2560x1440@60,2560x0,1
  '';

  # Git
  #programs.git.config.user.signingkey = "6CF9E05D378A01C5";

  ### Programs ###
  # VPN
  configured.programs.mullvad.enable = true;
  # Games
  programs.steam.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}


