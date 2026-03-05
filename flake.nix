{

  inputs = {
    nixpkgsStable.url = "nixpkgs/nixos-25.11";
    nixpkgsUnstable.url = "nixpkgs/nixos-unstable";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgsStable";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };
  };
  
  outputs = 
  { self, nixpkgsStable, nixpkgsUnstable, zen-browser, ... } @ inputs:
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

        { environment.systemPackages = [ inputs.zen-browser.packages.${system}.default ]; }

        ];
      specialArgs = {
        inherit username;
        inherit pkgsUnstable;
        inherit inputs;
        };

      };
    };
  };

}
