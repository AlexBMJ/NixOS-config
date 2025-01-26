{ pkgs, inputs, username, ... }:
let
  homeDirectory = "/home/${username}";
in
{
  home = { inherit username homeDirectory; };

  home.packages = with pkgs; [
    # Media players
    jellyfin-media-player
    stremio

    swaybg    # Wallpaper Tool

    sshfs     # Remote filesystems over SSH
    vesktop   # Third-party Discord

    inkscape
    prismlauncher # Minecraft Launcher

    inputs.neovim.packages.${pkgs.system}.default
    wl-clipboard
  ];

  programs = {
    git = {
      enable = true;
      userName = "AlexBMJ";
      userEmail = "33891167+AlexBMJ@users.noreply.github.com";
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    obs-studio.enable = true;
  };
}


