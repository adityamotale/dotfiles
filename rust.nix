{
  description = "Flake for rust projects";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-wsl.url = "github:nix-community/nixos-wsl/release-25.05";
  };
  outputs = {  nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          name = "rust";
          buildInputs = with pkgs; [
            gcc
            rustc
            cargo
            rustfmt
            clippy
            rust-analyzer
          ];
        };
      });
}
