{ ... }:

{
  virtualisation.oci-containers = {
    backend = "docker";

    containers.athens = {
      image = "gomods/athens:latest";
      ports = [ "127.0.0.1:9000:3000" ];
      volumes = [ "athens:/var/lib/athens" ];
      environment = {
        ATHENS_DISK_STORAGE_ROOT = "/var/lib/athens";
        ATHENS_STORAGE_TYPE = "disk";
      };
    };

  };
}
