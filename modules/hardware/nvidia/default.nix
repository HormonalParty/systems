{ ... }:

{
  services.xserver = {
    enable = false;
    videoDrivers = [ "nvidia" ];
  };

  hardware.nvidia.nvidiaPersistenced = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
