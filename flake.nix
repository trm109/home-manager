{
  description = "Home Manager configuration of saik";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations = {
        viceroy = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            hostname = "viceroy"; # used to differentiate between machines.
            formfactor = "desktop"; # used to set defaults for the form factor of the machine, e.g. desktop, laptop, server.
          };

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            ./home.nix
            inputs.nixvim.homeModules.nixvim
          ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };
        asus-flow = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            hostname = "asus-flow"; # used to differentiate between machines.
            formfactor = "laptop"; # used to set defaults for the form factor of the machine, e.g. desktop, laptop, server.
          };

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            ./home.nix
            inputs.nixvim.homeModules.nixvim
          ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };
      };
    };
}
