{ config, pkgs, lib, ... }:
{
  imports = [
    ./nix
    ./minimal-ops.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
