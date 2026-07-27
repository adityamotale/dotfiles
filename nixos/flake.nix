# Run using `sudo nixos-rebuild switch --flake .#default`

{
  description = "";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-gtkwave.url = "github:NixOS/nixpkgs/f665af0cdb70ed27e1bd8f9fdfecaf451260fc55";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-gtkwave, nixos-wsl, ... }: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit nixos-wsl;
        inherit nixpkgs-gtkwave;
      };

      modules = [
        ./configuration.nix
      ];
    };
  };
}
