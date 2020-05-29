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

  networking.hostName = "berlin.infra.hormonal.party";
  networking.hostId = "7d25489c";

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
        address = "178.63.8.90";
        prefixLength = 26;
      }];
      ipv6.addresses = [{
        address = "2a01:4f8:110:437b::1";
        prefixLength = 64;
      }];
    };
    defaultGateway = "178.63.8.65";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    nameservers = [
      "213.133.98.98" "213.133.99.99" "213.133.100.100"
      "2a01:4f8:0:a0a1::add:1010" "2a01:4f8:0:a102::add:9999"
      "2a01:4f8:0:a111::add:9898"
    ];
  };

  time.timeZone = "UTC";

  system.stateVersion = "20.09";
}
