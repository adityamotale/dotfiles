{ config, lib, pkgs, nixos-wsl, nixpkgs-gtkwave, ... }:

let
  oldPkgs = import nixpkgs-gtkwave {
    system = pkgs.system;
  };
in
{
  imports = [
    nixos-wsl.nixosModules.default
  ];

  time.timeZone = "Asia/Kolkata";
  wsl.enable = true;
  wsl.defaultUser = "nixos";

  system.stateVersion = "26.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
        git
        curl
        helix
        starship
        nasm
        gcc
        gcc.libc
        clang-tools
        gdb
        glibc.static
        perf
        asm-lsp

        gnumake
        iverilog
        oldPkgs.gtkwave
        verible
        ripgrep
        tree
        just
  ];
}
