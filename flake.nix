{
    description = "Getting started";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

        home-manager = {
            url = "github:nix-community/home-manager/release-23.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
	    tmux.url = "github:NixOS/nixpkgs/0ffaecb6f04404db2c739beb167a5942993cfd87";
    };

    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
      let
        lib = nixpkgs.lib;

        # https://nixos.wiki/wiki/Overlays
        unstable-overlay = final: prev: {
            unstable = nixpkgs-unstable.legacyPackages.${prev.system};
        };

        # Pull in tmux 3.1c to work-around: https://github.com/tmux/tmux/issues/2705
        tmux-overlay = final: prev: {
            tmux = nixpkgs-unstable.legacyPackages.${prev.system};
        };

        pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = { allowUnfree = true; };
            overlays = [
                unstable-overlay
                tmux-overlay
            ];
        };

      in {

          nixosConfigurations = {
              virtualbox = lib.nixosSystem {
                  inherit pkgs;
                  system = "x86_64-linux";
                  modules = [
                    ./machines/virtualbox/configuration.nix
                    home-manager.nixosModule {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.users.rbjorklin = import ./home.nix;
                    }

                  ];
              };
          };
      };
}
