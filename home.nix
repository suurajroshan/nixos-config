# /etc/nixos/home.nix
{config, pkgs, pkgsUnstable, ... }:

{
  # Set your home-manager state version
  home.stateVersion = "25.05"; # Or whatever your NixOS version is

  # Tell home-manager who you are
  home.username = "suuper";
  home.homeDirectory = "/home/suuper";

  home.file = {

  };

  home.sessionVariables = {

  }; 

}


