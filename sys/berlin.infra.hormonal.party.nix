{ config, lib, pkgs, ... }:

{
  imports = [
    ../modules/defaults.nix
  ];
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "rpool/root";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/36a0ab77-f363-4ce9-8105-fdd85ce2a545";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { device = "rpool/home";
      fsType = "zfs";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/dc582454-e81c-477d-bf70-9695a2cc2e35"; }
      { device = "/dev/disk/by-uuid/7dc74649-ef6b-4147-86b8-b8070f84c6da"; }
    ];

  nix.maxJobs = lib.mkDefault 12;

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = false;
  boot.loader.grub.devices = [
    "/dev/nvme0n1" "/dev/nvme1n1"
  ];

  boot.tmpOnTmpfs = true;

  hardware.cpu.amd.updateMicrocode = true;

  networking.hostName = "berlin.infra.hormonal.party";
  networking.hostId = "7d25489c";
  networking = {
    #networkmanager = {
    #  enable = true;
    #};
    usePredictableInterfaceNames = false;
    enableIPv6 = true;
    interfaces.eth0.useDHCP = false;
    interfaces.eth0.ipv4.addresses = [{
      address = "178.63.8.90";
      prefixLength = 26;
    }];
    interfaces.eth0.ipv6.addresses = [{
      address = "2a01:4f8:110:437b::1";
      prefixLength = 64;
    }];
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

  services.zfs.autoScrub.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 22 ];
    enable = true;
  };

  programs.fish = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  users.users.maxine = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKDmex7rvB7BFd9OxQHfgqKogiN69kHvixCzWWEGh5oY maxine@chirm"
    ];
  };

  users.users.danielle = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDy6nsIHNmq0zzkXbjutADn2cjOoLjz70+yQPnDku9Da/BdmjQEoArsojI/l5WuP0D2+xUXEOLQonGF1LKdBiBrCn775PVF/wd4MlW1a7uyXiFlYu4a2H8dgaQ79E85/Tpzc9AwzkVb+vq1oii49yQFarc7RHrqXikQ9yDTqWZQ5BYZUSXZVZ+ZCct9Y/3xxQyMD7i1eTaf7t2HfIUusAVzIXfpUfFQ2XxUyoJtRrG2hgTIdUikN0+JDD8Th1d+rPIw+uYNwbrw9qEpMY8MXT4Od8i7/j8Wwyo4iOF04n2nNmV+p1ToQ6iiduZZZ3/npRdhzbgXJK5TNq98R66Igiit"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "20.09";
}

