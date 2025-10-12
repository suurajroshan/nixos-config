{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ openrgb ];
  services.hardware.openrgb = { 
    enable = true; 
    package = pkgs.openrgb-with-all-plugins; 
    motherboard = "intel"; 
    server = { 
      port = 6742; 
    }; 
  };
  users.users.suuper.extraGroups = [ "openrgb" ];
  boot.blacklistedKernelModules = [ "hid_sensor_hub" ];
}
