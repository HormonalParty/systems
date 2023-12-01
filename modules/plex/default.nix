{ config, lib, pkgs, ... }:

{
  services.plex = {
    enable = true;
    openFirewall = false;
    extraPlugins = [
      (builtins.path {
        name = "Audnexus.bundle";
        path = pkgs.fetchFromGitHub {
          owner = "djdembeck";
          repo = "Audnexus.bundle";
          rev = "v1.3.1";
          sha256 = "sha256-HgbPZdKZq3uT44n+4owjPajBbkEENexyPwkFuriiqU4=";
        };
      })
      (builtins.path {
        name = "XBMCnfoMoviesImporter.bundle";
        path = pkgs.fetchFromGitHub {
          owner = "gboudreau";
          repo = "XBMCnfoMoviesImporter.bundle";
          rev = "d81d1f8768cf3874787016126f9d3fca70e87593";
          sha256 = "sha256-Epd6VHIfXsTXlOyWkSDHbg5Uxs7Y7/EMza7z31rckzo=";
        };
      })
    ];
  };

  users.groups.media.members = [ "danielle" "maxine" "plex" ];

  fileSystems."/mnt/media" = {
    device = "/storage/media";
    options = [ "bind" ];
  };
}
