inputs:
let
  baseModules = with inputs; [
    ../modules
    agenix.nixosModules.default
    disko.nixosModules.disko
    home-manager.nixosModule
    hyprland.nixosModules.default
    nur.modules.nixos.default
    {
      users.mutableUsers = false;
    }
    ({ username, ... }: {
      home-manager.enable = true;
      users.users.${username} = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };
    })
  ];

  mkSystem = name: {
    system ? "x86_64-linux",
    channel ? inputs.nixpkgs-unstable,
    username ? "albmj"
  }: channel.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs username; };
      modules =
        baseModules
        ++
        [({ lib, ... }: {
          imports = [ ./${name}/configuration.nix ];
          networking.hostName = name;
          age.identityPaths = [ "/home/${username}/.ssh/id_ed25519" ];
        })];
    };

in inputs.nixpkgs.lib.mapAttrs mkSystem {
  BMJ-Desktop  = {};  # Desktop
}

