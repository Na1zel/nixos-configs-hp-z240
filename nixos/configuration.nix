{ config, pkgs, pkgs-stable, lib, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # ============================================================
  # Boot
  # ============================================================

  boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
  
      kernelPackages = pkgs.linuxPackages_zen;
  
      kernel.sysctl."kernel.sysrq" = 1;
  
      extraModprobeConfig = ''
        options rtw88_core disable_lps_deep=Y
      '';
  
      tmp.useTmpfs = true; # если не 32gb ram и если хочешь что то большое компилировать то ставь временно boot.tmp.cleanOnBoot = true;
    };

  # ============================================================
  # Scheduler / Memory / Zram / Swap
  # ============================================================

  #services.scx = {
  #  enable = true;
  #  scheduler = "scx_bpfland";
  #};

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  # ============================================================
  # Filesystems
  # ============================================================

  fileSystems."/".options = [ "defaults" "noatime" "compress=zstd" ];
  fileSystems."/nix".options = [ "defaults" "noatime" "compress=zstd" ];

  fileSystems."/home/naizel/hdd1tb" = {
    device = lib.mkForce "/dev/disk/by-label/hdd1tb";
    fsType = "btrfs";
    options = [ "defaults" "noatime" "compress=zstd" ];
  };

  fileSystems."/home/naizel/ssd500gb" = {
    device = lib.mkForce "/dev/disk/by-label/ssd500gb";
    fsType = "btrfs";
    options = [ "defaults" "noatime" "compress=zstd" ];
  };

  services.fstrim = {
  	enable = true;
  	interval = "weekly";
  };

  # sudo chown -R $USER:users /home/naizel/ssd500gb # НАПИСАТЬ в терминале когда поставли этот конфиг
  # sudo chown -R $USER:users /home/naizel/hdd1tb
  # sudo chmod -R 755 /home/naizel/hdd1tb
  # sudo chmod -R 755 /home/naizel/ssd500gb

  # ============================================================
  # Power / Logind
  # ============================================================

  services.logind.settings.Login = {
    IdleAction = "ignore";
  };

  systemd.targets.hibernate.enable = false; # убери если есть swap + zram
  systemd.targets.hybrid-sleep.enable = false; # убери если есть swap + zram
  systemd.targets.suspend.enable = false; # убери если есть swap + zram

  # ============================================================
  # Networking
  # ============================================================

  networking = {
    hostName = "nixos";
  
    networkmanager = {
      enable = true;
  
      wifi = {
        backend = "iwd";
        powersave = false;
      };
    };
  
    wireless.iwd.enable = true;
  
    nftables.enable = true;
  };
  
  # ============================================================
  # Nix
  # ============================================================

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    auto-optimise-store = true;
    keep-outputs = true;
    keep-derivations = true;
  };

  # ============================================================
  # Locale
  # ============================================================

  time.timeZone = "Europe/Zurich";
  
    i18n = {
      defaultLocale = "ru_RU.UTF-8";
  
      supportedLocales = [
        "en_US.UTF-8/UTF-8"
        "ru_RU.UTF-8/UTF-8"
      ];
  
      extraLocaleSettings = {
        LC_ADDRESS = "ru_RU.UTF-8";
        LC_IDENTIFICATION = "ru_RU.UTF-8";
        LC_MEASUREMENT = "ru_RU.UTF-8";
        LC_MONETARY = "ru_RU.UTF-8";
        LC_NAME = "ru_RU.UTF-8";
        LC_NUMERIC = "ru_RU.UTF-8";
        LC_PAPER = "ru_RU.UTF-8";
        LC_TELEPHONE = "ru_RU.UTF-8";
        LC_TIME = "ru_RU.UTF-8";
      };
    };

  # ============================================================
  # Graphics / NVIDIA
  # ============================================================

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };
  
  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.nvidia = {
    open = true;
    nvidiaSettings = true;
    modesetting.enable = true;
  };
  
  environment.sessionVariables = {
    __GL_SHADER_DISK_CACHE_SIZE = "8589934592";
  };

  # ============================================================
  # Dekstop / KDE
  # ============================================================

  services.desktopManager.plasma6.enable = true; #выключить blur что не подтармаживала на видеокартах nvidia либо поставить DX Blur, он это фиксить 
  #services.displayManager.plasma-login-manager.enable = true; если с ly баги но врубай это и вырубай ly
  services.displayManager.ly = {
    enable = true;
  };

  programs.dconf.enable = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  programs.nh.enable = true;

  environment.localBinInPath = true;

  # ============================================================
  # Packages
  # ============================================================

  environment.systemPackages = with pkgs; [

    # Theme / QT / GTK
    caelestia-shell
    caelestia-cli
    adw-gtk3
    gnupg
    rusty-path-of-building
    bibata-cursors
    kdePackages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtmultimedia
    adwaita-icon-theme
    sbctl
    pipewire
    dmidecode
    inxi
    dnsmasq

    # Editors / IDE
    micro

    # File managers / viewers / apps for work
    upscayl
    upscaler
    darktable
    blender
    exfatprogs
    libreoffice-qt

    # Media
    yt-dlp
    mpv
    cava
    playerctl
    libnotify
    imagemagick
    pulseaudio
    haruna


    # Torrent
    qbittorrent-enhanced
    wget
    wget2
    curl

    # Monitoring / System
    fastfetch
    pfetch-rs
    pipes-rs
    bat
    btop-cuda # ставить просто btop если не nvidia
    htop
    eza
    cmatrix
    tty-clock
    efibootmgr
    pciutils
    usbutils
    unzip
    zip
    innoextract
    p7zip
    lshw
    smartmontools
    nvtopPackages.full # если проблемы со скачиванием то закоментируй на время потом убери #
    ncdu
    duf
    fzf
    strace
    lsof
    ffmpeg
    ani-cli
    fuse
    fuse3
    libusb1
    file
    abootimg
    ntfs3g
    libva-utils
    nftables

    # Terminal
    yazi
    tldr
    zellij
    unrar

    # Gaming
    mangohud
    faugus-launcher
    mesa-demos
    gwe
    vkbasalt
    vkbasalt-cli
    vulkan-tools
    goverlay
    protonplus
    protontricks
    heroic
    prismlauncher
    gamemode
    steam-run
    steamcmd
    wineWow64Packages.waylandFull
    winetricks
    protonup-qt
    #nzportable # убрать когда выйдет уже 2.0.0 стабильный релиз
    #angband # убрать если хочешь поставить
    #supertux # убрать если хочешь поставить
    #supertuxkart # убрать когда выйдет 2.0 evoltuin обновление

    # Desktop
    wl-clipboard
    grim
    slurp
    pamixer
    wev

    # Network
    nmap
    zenmap
    netcat-gnu
    traceroute
    dig
    iw

    # VPN / Proxy
    openvpn
    openconnect
    wireguard-tools
    v2ray
    xray
    sing-box
    mihomo
    tor
    tor-browser
    proxychains-ng
    privoxy

    # Hardware
    ddcutil
    ddccontrol
    overskride
    usb-modeswitch
    usb-modeswitch-data

    # Apps
    ayugram-desktop
    vesktop
    krita
    gimp
    kdePackages.kdenlive
    kdePackages.partitionmanager

    # Dev
    git
    lazygit
    ripgrep
    fd
    tree-sitter
    tree
    jq
    yq
    perl
    httpie

    gcc
    clang
    clang-tools
    gnumake
    cmake
    ninja
    binutils
    gdb
    lld
    pkg-config
    autoconf
    automake
    libtool
    patch
    fakeroot

    python3
    python3Packages.python-lsp-server
    uv

    #rustc # Добавить если надо
    #cargo
    #rust-analyzer
    #rustfmt
    #clippy

    #go
    #gopls
    #gotools
    #golangci-lint

    nodejs

    jdk
    maven
    gradle
    jdt-language-server

    lua
    luajit
    luarocks
    lua-language-server
    stylua

    statix
    nix-init
    deadnix
    nvd
    nix-output-monitor
    nix-tree
    nix-du
    nixd
    nil
    nixfmt

    bash-language-server
    shellcheck
    shfmt
    pyright

    marksman
    yaml-language-server
    taplo
    sqls

    ccls
    clang-analyzer

    sqlite
    sqlitebrowser

  # ============================================================
  # Stable packages
  # ============================================================

  ] ++ (with pkgs-stable; [

    #stable-packagessssss

  ]);

  # ============================================================
  # Gaming
  # ============================================================

  programs.gpu-screen-recorder.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
    gamescopeSession.enable = true;
  };

  hardware.steam-hardware.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = true; #закоментируй если хочешь стимдек
  };

  programs.gamemode.enable = true;

  # ============================================================
  # Flatpak
  # ============================================================

  services.flatpak.enable = true; # напиши что бы доавбить репозиторий он кстати императивый так что иди и ручками всё делай flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  # ============================================================
  # Services
  # ============================================================

  services.upower.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.ddccontrol.enable = true;
  services.power-profiles-daemon.enable = false;
  powerManagement.cpuFreqGovernor = "performance";

  security.polkit.enable = true;

  services.accounts-daemon.enable = true;

  services.tumbler.enable = true;

  # ============================================================
  # Audio
  # ============================================================

  services.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;

    pulse.enable = true;

    wireplumber.enable = true;
  };

  # ============================================================
  # Bluetooth
  # ============================================================

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  
    settings = {
      General = {
        ControllerMode = "dual";
        FastConnectable = true;
        Experimental = true;
      };
    };
  };
  
  hardware.xpadneo.enable = true;

  # ============================================================
  # USB-modeswitch
  # ============================================================

  services.udev.packages = [
    pkgs.usb-modeswitch-data
  ];

  hardware.usb-modeswitch.enable = true;

  hardware.i2c.enable = true;

  # ============================================================
  # Console / Fonts
  # ============================================================

  console = {
    font = "ter-v16b";

    keyMap = "ruwin_alt_sh-UTF-8";

    packages = [
      pkgs.terminus_font
    ];

    earlySetup = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    roboto
    cantarell-fonts
  ];

  # ============================================================
  # Other Programs
  # ============================================================

  programs.fish.enable = true;

  programs.kdeconnect.enable = true;

  programs.partition-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ============================================================
  # User
  # ============================================================

  users.users.naizel = {
    isNormalUser = true;

    description = "naizel";

    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "i2c"
      "wireshark"
      "gamemode"
    ];

    shell = pkgs.fish;
  };

  # ============================================================
  # Firmware
  # ============================================================

  hardware.enableRedistributableFirmware = true;

  services.fwupd.enable = true;

  hardware.cpu.intel.updateMicrocode = true; # или есть amd процесор hardware.cpu.amd.updateMicrocode = true;

  # ============================================================
  # System
  # ============================================================

  system.stateVersion = "26.05"; # меняй на свою когда будешь ставить первый раз
}
