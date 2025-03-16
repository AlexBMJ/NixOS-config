{ config, pkgs, lib, username, inputs, ... }:
with lib;
let
  module_name = "hyprland";
  cfg = config.desktops."${module_name}";
in {
  options.desktops."${module_name}" = {
    enable = mkEnableOption "Enable the Hyprland Wayland Compositor";
    extraConfig = mkOption {
      type = types.str;
      default = "";
    };
  };

  imports = [
    ../../home-manager.nix
  ];

  config = mkIf cfg.enable {
    home-manager.extraSpecialArgs = {
      extraHyprConfig = cfg.extraConfig;
    };
    home-manager.users.${username} = {
      imports = [
        inputs.hyprland.homeManagerModules.default
        inputs.ags.homeManagerModules.default
        ./home.nix
      ];
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # PAM
    security.pam.services.hyprlock = {};
    security.pam.services.greetd.gnupg = {
      enable = true;
      noAutostart = true;
      storeOnly = true;
    };

    # Networking
    services.resolved.enable = true;
    networking.networkmanager.enable = true;
    users.users.${username}.extraGroups = [ "networkmanager" ];

    # Compositor
    programs.hyprland.enable = true;

    # Display Manager
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    # Browser
    configured.programs.firefox.enable = true;
    configured.programs.firefox.defaultBrowser = true;

    # Application Launcher
    configured.programs.rofi.enable = true;
    # Terminal Emulator
    configured.programs.zsh.enable = true;
    # File Manager
    configured.programs.thunar.enable = true;
    # Pipewire
    configured.programs.pipewire.enable = true;

    # NOTE: mkIf bluetooth?
    # Bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # Fonts
    fonts.packages = with pkgs; [
      nerd-fonts.caskaydia-cove
      noto-fonts
    ];

    # SSH
    programs.ssh.startAgent = false; # gpg-agent emulates ssh-agent. So we can use both SSH and GPG keys.

    # Git
    programs.git = {
      enable = true;
      config = {
        commit.gpgsign = false;
        core.autocrlf = "input";
      };
    };

    # Podman
    virtualisation.containers.enable = true;
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    # Nix Settings
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
}
