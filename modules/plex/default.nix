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
          rev = "v0.4.0";
          sha256 = "sha256-9xNvOBmdWcOhTGLLs5fv6/5kq9eyocrWMkdpZanVO/s=";
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
