#DUse your harware-configuration.nix


{ config, pkgs, pkgsUnstable, ... }:

{
  imports =
    [
      #      ./modules/openrgb.nix
      ./modules/users.nix
      ./hardware-configuration.nix
      ./fonts.nix
      ./pipewire.nix
      ./modules/packages.nix
      ./vm.nix
    ];

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.devices = [ "nodev" ] ;
  boot.loader.grub.efiSupport = true;	
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nixos"; # Define your hostname.
  systemd.services.NetworkManager-wait-online.enable = false;
  
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8"];

  # Enable networking
  networking.networkmanager = {
    enable = true;
};
  networking.networkmanager.plugins = with pkgsUnstable; [ 
    networkmanager-openvpn
  ];

  # eduVPN settings
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
    checkReversePath = "loose";
  };


  hardware.bluetooth.enable = true;
  services.pulseaudio.enable = false;
  # Enable i2c
  hardware.i2c.enable = true;

# Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable Hyprland
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable the GNOME Desktop Environment.
  services.xserver.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  systemd.services.ModemManager.enable = true;

  services.usbmuxd.enable = true;

  services.power-profiles-daemon.enable = false;

  services.displayManager = { 
    #  sessionPackages = [ pkgs.gnome.gnome-session.sessions ];
  #  sddm.enable = true;
  };
  # Kernel modules load
  # boot.extraModulePackages = [ config.boot.kernelModules.ddcci-driver ];
  
  # Virtualisation
  boot.kernelModules = [ "kvm-intel" ];
  #  boot.extraModprobeConfig = ''
  #  options usbhid quirks=0x03f0:0x1441:0x00000000
  #'';
swapDevices = [{
  device = "/var/lib/swapfile";
  size = 16*1024; # 16 GB
}];
  virtualisation.docker = {
    enable = true;
  };

  services.udev.extraRules = ''                                                                                                                                                      
        KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"                                                                                                                                 
  #      SUBSYSTEM=="usb", ATTRS{idVendor}=="03f0", ATTRS{idProduct}=="1441", ATTR{bInterfaceClass}=="03", RUN+="/bin/sh -c 'echo $kernel > /sys/bus/usb/drivers/usbhid/bind'"          
  '';

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  
  services.samba = {
    package = pkgs.samba4Full;
        # ^^ `samba4Full` is compiled with avahi, ldap, AD etc support (compared to the default package, `samba`
        # Required for samba to register mDNS records for auto discovery 
        # See https://github.com/NixOS/nixpkgs/blob/592047fc9e4f7b74a4dc85d1b9f5243dfe4899e3/pkgs/top-level/all-packages.nix#L27268
    enable = true;
    openFirewall = true;
    settings.testshare = {
      path = "/path/to/share";
      writable = "true";
      comment = "Hello World!";
    };
    settings.global.extraConfig = ''
          server smb encrypt = required
          # ^^ Note: Breaks `smbclient -L <ip/host> -U%` by default, might require the client to set `client min protocol`?
          server min protocol = SMB3_00
        '';
  };

  services.avahi = {
    publish.enable = true;
    publish.userServices = true;
    # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
    nssmdns4 = true;
    # ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
	  enable = true;
    openFirewall = true;
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable adb 
  programs.adb.enable = true;  

  services.flatpak.enable = true;
  programs.firefox.enable = false;
  #programs.gh.enable = true;
  programs.thunar.enable = true;
  programs.neovim = {
  	enable = true;
	defaultEditor = true;
  };
  programs.ssh.startAgent = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  fileSystems."/mnt/share" = {
    device = "//131.188.251.29";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

    in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-hyprland
    ];
  }; 
  # Enable automatic garbage collection
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";  # Runs garbage collection weekly
  nix.gc.options = "--delete-older-than 30d";
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = "75";
      STOP_CHARGE_THRESH_BAT0 = "80";

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

    };
  };
nixpkgs = {
  overlays = [
    (self: super: {
      gnome-shell = super.gnome-shell.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
          (self.pkgs.writeText "bg.patch" ''
            --- a/data/theme/gnome-shell-sass/widgets/_login-lock.scss
            +++ b/data/theme/gnome-shell-sass/widgets/_login-lock.scss
            @@ -15,4 +15,5 @@ $_gdm_dialog_width: 23em;
             /* Login Dialog */
             .login-dialog {
               background-color: $_gdm_bg;
            +  background-color: #000000;
             }
          '')
        ];
      });
    })
  ];
};

  # List services that you want to enable:
  services.xrdp = {
    enable = true;
    openFirewall = true;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 3389 ];
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # Channels to flakes
}
