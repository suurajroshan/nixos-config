{

  description = "Trying out flake!";
  
  inputs = {
    nixpkgsStable.url = "nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgsStable"; # looks for same version of packages
    nixpkgsUnstable.url = "nixpkgs/nixos-unstable";
  };
  
  outputs = 
  { self, nixpkgsStable, nixpkgsUnstable, home-manager,... } @ inputs:
    let
      lib = nixpkgsStable.lib; # It is like pass nixpkgs to this var
      system = "x86_64-linux";
      #lib-un = inputs.nixpkgUnstable.lib;
      pkgs = nixpkgsStable.legacyPackages.${system};
      pkgsUnstable = nixpkgsUnstable.legacyPackages.${system};
      username = "suuper";
    in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;        
      modules = [

        ./configuration.nix

        home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.users.suuper = import ./home.nix;
        }
        ];
      specialArgs = {
        inherit username;
        inherit pkgsUnstable;
        };

      };
    };
  };

}
