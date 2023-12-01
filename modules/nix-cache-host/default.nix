{ config, lib, pkgs, ... }:

{
  services.nix-serve = {
    package = pkgs.nix-serve.override {
      nix = pkgs.nixVersions.nix_2_12;
    };
    enable = true;
    port = 9003;
    bindAddress = "127.0.0.1";
    secretKeyFile = "/var/bincache.d/cache-priv-key.pem";
  };
}
