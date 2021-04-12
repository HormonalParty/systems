{ config, lib, pkgs, ... }:

{
  services.nix-serve = {
    enable = true;
    port = 9003;
    secretKeyFile = "/var/bincache.d/cache-priv-key.pem";
  };
}
