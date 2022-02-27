{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/default
    ../../modules/hardware/amd
    ../../modules/remote-build-host
    ../../modules/zfs
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = false;
    devices = [
      "/dev/nvme0n1" "/dev/nvme1n1"
    ];
  };

  networking.hostName = "lisbon";
  networking.domain = "infra.hormonal.party";
  networking.hostId = "9cd372da";

  networking = {
    firewall = {
      allowedTCPPorts = [ 22 ];
      enable = true;
    };

    usePredictableInterfaceNames = false;
    enableIPv6 = true;
    interfaces.eth0 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "65.108.68.203";
        prefixLength = 26;
      }];
      ipv6.addresses = [{
        address = "2a01:4f9:6b:44da::1";
        prefixLength = 64;
      }];
    };
    defaultGateway = "65.108.68.193";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    nameservers = [
      "185.12.64.1" "185.12.64.2"
      "2a01:4ff:ff00::add:1" "2a01:4ff:ff00::add:2"
    ];
  };

  time.timeZone = "UTC";

  system.stateVersion = "22.05";

  virtualisation.docker.enable = true;

  virtualisation.oci-containers.backend = "docker";
}
