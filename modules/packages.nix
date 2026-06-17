
{ pkgs, pkgsUnstable, inputs, ... }: {
environment.systemPackages =
(with pkgsUnstable; [
  quickshell
  inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
])
++

    ( with pkgs; [
    # === 1. Window Managers & Desktop Environment ===
    dms-shell
    fuzzel
    grim
    hypridle
    hyprland
    hyprpaper
    hyprpicker
    hyprshot
    libnotify
    niri
    rofi
    slurp
    waybar
    wl-clipboard
    xclip
    xwayland-satellite            # needed for niri
  
    # === 2. Themes, Looks & Customization ===
    bibata-cursors
    cmatrix
    fastfetch
    nwg-look
    papirus-icon-theme
    phinger-cursors
  
    # === 3. Shells, Terminals & Prompts ===
    alacritty
    bash
    kitty
    starship
  
    # === 4. Core Development & Programming Languages ===
    # -- c / c++
    cmake
    gcc
    gnumake
    libgcc
    
    # -- python
    conda
    python3
    python3Packages.dbus-python
    python312Packages.smbprotocol
    
    # -- ruby
    bundler
    ruby
    
    # -- lua
    lua
    luajitPackages.luarocks
    
    # -- dev ops & version control
    gh
    git
    github-desktop
    mpi
    nix
    stow
  
    # === 5. Text Editors & IDEs ===
    geany
    neovim
    #sublime4                     # commented out per source
    vscode
    zed-editor
  
    # === 6. Web Browsers ===
    brave
    chromium
    chromedriver
    firefox
    microsoft-edge
    vivaldi
    vivaldi-ffmpeg-codecs
  
    # === 7. Communication & Email ===
    discord
    slack
    thunderbird
    zoom-us
  
    # === 8. Productivity, Notes & Office ===
    inkscape-with-extensions
    keepassxc
    libreoffice-still
    obsidian
    kdePackages.okular
    pdfarranger
    qalculate-gtk
    sticky
    zotero
  
    # === 9. Media & Graphics ===
    eyedropper
    ffmpeg-full
    fswebcam
    qimgv
    vlc
    wl-color-picker
  
    # === 10. Hardware, Audio & Network Control ===
    blueman
    brightnessctl
    dconf
    ddcui
    ddcutil
    eduvpn-client
    gnome-control-center
    iw
    libmbim
    libqmi
    linux-wifi-hotspot
    macchanger
    modemmanager
    openconnect
    pamixer
    pavucontrol
    playerctl
    solaar
    wireguard-tools
  
    # === 11. File Management & Archiving ===
    bzip2
    exfatprogs
    gnome.gvfs
    gparted
    gvfs
    nautilus
    p7zip
    parted
    unzip
    zip
  
    # === 12. CLI Utilities (The "Swiss Army Knives") ===
    bat
    btop
    coreutils
    cowsay
    eza
    fd
    fzf
    gnugrep
    htop
    killall
    lsof
    pciutils
    ripgrep
    ripgrep-all
    tealdeer
    trash-cli
    tre
    tree
    usbutils
    wget
    xdg-utils
    zoxide
  
    # === 13. Networking Protocols & File Sharing ===
    cifs-utils
    ifuse
    libimobiledevice
    samba
    wsdd
  
    # === 14. File Systems & Low-Level System Libraries ===
    haveged
    hfsprogs
    libffi
    ncurses
    ntfs3g
    openssl
    readline
  
    # === 15. Virtualization & Remote Desktop ===
    freerdp
    gnome-boxes
    rdesktop
    remmina
    scrcpy
    virtualbox
  ]);
}
