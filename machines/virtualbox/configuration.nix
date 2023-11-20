# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, ... }:

let
  unstable = import
    (builtins.fetchTarball {
    	name = "nixos-unstable-2023-11-17";
	url = "https://github.com/NixOS/nixpkgs/archive/ddf1381181e79e0ba76e031d13ce9397918d3af3.tar.gz";
        sha256 = "0rv3l7q1s2ki15z1msj86zkj77xngx31qa9l2iqd6lyzjp3i48ah";
        }
    )
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in

let
  # https://lazamar.co.uk/nix-versions/
  good_tmux = import (builtins.fetchTarball {
  	name = "tmux-3.1c";
	url = "https://github.com/NixOS/nixpkgs/archive/0ffaecb6f04404db2c739beb167a5942993cfd87.tar.gz";
        sha256 = "1cpz6c9k8limrd84sp7rayn8ghv5v0pym8gjhg4vz9bdc9ikh4az";
	}
  )
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in

# https://discourse.nixos.org/t/how-to-create-a-timestamp-in-a-nix-expression/30329/2
#let getIp = with config;
#	pkgs.runCommand "get-ip" {  __impure = true; sandbox = false; } ''
#	  ${pkgs.iproute}/bin/ip -4 -brief addr show dev enp0s3 | ${pkgs.gawk}/bin/awk '{print $3}' > $out
#	'';
#in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];
  hardware = {
    opengl.enable = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "net.ipv6.conf.all.disable_ipv6" = 1;
  };

  documentation.man = {
    enable = true;
    generateCaches = true;
  };

  systemd.network.enable = true;
  systemd.network.config.dhcpV4Config = { DUIDType = "link-layer"; };
  # systemd-networkd-wait-online.service waits for any address on an interface
  # ipv6 addresses are not useful to me yet.
  systemd.network.wait-online.extraArgs = [ "--ipv4" ];
  systemd.network.wait-online.anyInterface = true;
  systemd.network.wait-online.timeout = 5;
  systemd.network.networks."10-enp0s3" = {
    enable = true;
    DHCP = "ipv4"; # "yes" for both
    matchConfig = { Name = "enp0s3"; };
  };


  networking.hostName = "nixos";
  # use systemd-networkd instead
  networking.dhcpcd.enable = false;

  time.timeZone = "America/Vancouver";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_CA.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_DK.UTF-8"; # 24h clock, ISO-8601 timestamps, in English
    };
    supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_CA.UTF-8/UTF-8"
      "en_DK.UTF-8/UTF-8" # 24h clock, ISO-8601 timestamps, in English
      "en_US.UTF-8/UTF-8"
      "sv_SE.UTF-8/UTF-8"
    ];
  };

  console = {
    keyMap = "colemak";
  };

  programs = {
    _1password.enable = true;
    _1password-gui.enable = true;
    _1password-gui.polkitPolicyOwners = [ "rbjorklin" ];
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    waybar.enable = true;
    zsh = {
      enable = true;
    };
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
  };
  
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true; # volume control
    jack.enable = true;
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-user-session --asterisks --cmd Hyprland";
    };
  };

  systemd.tmpfiles.rules = [
    # https://github.com/NixOS/nixpkgs/issues/248323
    "d '/var/cache/tuigreet' - greeter greeter - -"
  ];

  security.polkit.enable = true;
  security.pam.services.greetd = {
    enableGnomeKeyring = true;
    gnupg.enable = true;
    #yubicoAuth = true;
  };

  # Required to get swaylock & swayidle on $PATH and for swaylock to register with pam.
  # https://github.com/nix-community/home-manager/pull/4416/files#diff-81ffdc4284f13266610da15d67b11e7b4d46e25c4ac59be3fd07be2dd56018a9R31
  # https://nix-community.github.io/home-manager/options.html#opt-programs.swaylock.enable
  security.pam.services.swaylock = {};

  services.gnome.gnome-settings-daemon.enable = true;
  
  nix = {
    optimise.automatic = true;
    gc.automatic = true;
    gc.options = "--delete-older-than 14d";
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      #extra-experimental-features = [ "impure-derivations" ];
      #sandbox = false;
      #extra-allowed-impure-host-deps = "/sys";
    };
  };
  nixpkgs.config.allowUnfree = true;

  users.users.rbjorklin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      alacritty
      bcc # # https://github.com/iovisor/bcc
      clusterctl
      cmake
      containerd
      copyq
      ctags
      curl
      d2
      direnv
      evince
      fd
      firefox
      fzf
      gcc
      gdk-pixbuf # nwg-look / GTK3 theming
      git
      glib # nwg-look / GTK3 theming
      gnome.adwaita-icon-theme # https://nixos.wiki/wiki/GNOME#Running_GNOME_programs_outside_of_GNOME
      gnome.eog
      gnome.gnome-keyring
      gnome.nautilus
      grim # grab images from Wayland
      hcloud
      inotify-tools # dune build --watch
      jq
      kind
      krew
      kubectl
      kubernetes-helm
      kustomize
      libev
      nerdctl
      networkmanagerapplet
      nmap
      unstable.nwg-look # GTK3 theming under Wayland
      opam
      packer
      patchelf # because NixOS does things its own way
      polkit_gnome
      postgresql.lib # This should be libpq but see: https://github.com/NixOS/nixpkgs/issues/61580
      pv
      reptyr
      ripgrep
      rPackages.fontawesome
      rr
      shellcheck
      slurp # select a region in a Wayland compositor
      sops
      spotify
      sqlite # zsh-histdb
      starship
      strace
      sysstat # provides iostat
      tldr
      tree
      vmtouch
      wl-clipboard
      xorg.libxshmfence # 1password dep?
      yq
      zip
      zsh
      zstd # OCaml 5.1.0
    ];
  };

  # fonts.packages in 23.11 and newer
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    unstable.monaspace
  ];

  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search curl
  environment.systemPackages = with pkgs; [
    age
    file
    gnome.gnome-control-center
    hdparm
    home-manager
    htop
    hyprland
    hyprpaper
    libnotify
    mako
    neovim
    nix-index
    pciutils
    pulseaudio # volume control
    swayidle
    swaylock
    good_tmux.tmux
    tofi
    unstable.monaspace
    unzip
    waybar
    wayland
    wdisplays # configure displays
    xdg-utils # open default program when clicking link
  ];

  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1"; #Virtualbox Only
    WLR_RENDERER_ALLOW_SOFTWARE = "1"; #Virtualbox Only
    LIBGL_ALWAYS_SOFTWARE = "1"; #Virtualbox Only
    LIBSEAT_BACKEND = "logind";
  };

  environment.etc = {
    issue.enable = false; # File managed by systemd service
  };

  systemd.services = {

    "write-etc-issue" = {
      enable = true;
      # systemd-networkd-wait-online.service waits for any address on all interfaces, sometimes ipv6 comes first...
      wants = [ "systemd-networkd-wait-online.service" "network-online.target" ];
      after = [ "systemd-networkd-wait-online.service" "network-online.target" ];
      wantedBy = [ "graphical.target" ];
      preStart = "${pkgs.iproute}/bin/ip link show dev enp0s3 up";
      serviceConfig = { RestartSec = 5; Restart = "on-failure"; };
      # String interpolation has a surprising escaping mechanism using two single quotes: ''
      # https://nixos.org/manual/nix/stable/language/values#type-string
      script = with config; ''
        ip_addr=''$(${pkgs.iproute}/bin/ip -4 -brief addr show dev enp0s3 | ${pkgs.gawk}/bin/awk '{print $3}')
        cat << EOF > /etc/issue
        Hostname: ${networking.hostName}
        OS:       NixOS ${system.nixos.release} (${system.nixos.codeName})
        Version:  ${system.nixos.version}
        Kernel:   ${boot.kernelPackages.kernel.version}
        Address:  ''${ip_addr}
        EOF
        '';
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.autoUpgrade.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
