{
  description = "Simon's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    blender-bin.url = "github:edolstra/nix-warez?dir=blender";
    firefox-gnome-theme = {
        url = "github:rafaelmardojai/firefox-gnome-theme/master";
        flake = false;
    };
    probe-rs-rules.url = "github:jneem/probe-rs-rules";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, firefox-gnome-theme, blender-bin, ... }: {
    nixosConfigurations.sajmon-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        forcedSystem = "x86_64-linux";
      };
      modules = [
        ({config, pkgs, ...}: { nixpkgs.overlays = [ blender-bin.overlays.default ]; })
        ./configuration.nix
        home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
                inherit firefox-gnome-theme;
            };
            home-manager.users.sajmon = ./home.nix;
          }
      ];
    };
  };
}
