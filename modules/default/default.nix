{ config, pkgs, lib, ... }:
{
  imports = [
    ../nix
    ../ops
    ../users
  ];

  nixpkgs.config.allowUnfree = true;
}
