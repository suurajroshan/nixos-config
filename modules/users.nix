# modules/users.nix
{config, pkgs, ...}:  

{
  users.users.suuper = {
    isNormalUser = true;
    description = "suuper";
    extraGroups = [ "adbusers" "sambashare" "networkmanager" "i2c" "wheel" "input" "libvirtd" "vboxusers" "qemu-libvirtd" "video" "audio" "disk" ];
    packages = with pkgs; [
        
        ];
    };
}