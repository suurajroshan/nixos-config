{ config, pkgs, ... }:
let
  openrgb-rules = pkgs.writeTextFile {
    name = "60-openrgb.rules";
    text = builtins.replaceStrings 
      ["/bin/chmod"] 
      ["${pkgs.coreutils}/bin/chmod"] 
      (builtins.readFile (builtins.fetchurl {
        url = "https://openrgb.org/releases/release_0.9/60-openrgb.rules";
        sha256 = "0f5bmz0q8gs26mhy4m55gvbvcyvd7c0bf92aal4dsyg9n7lyq6xp"; # You'll need the real hash
      }));
  };
in
{
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];
  services.udev.extraRules = builtins.readFile openrgb-rules;
  environment.systemPackages = with pkgs; [ openrgb ];
}
