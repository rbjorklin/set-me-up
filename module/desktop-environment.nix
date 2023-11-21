{ config, pkgs, lib, ... }:

{
  programs = {
    _1password.enable = true;
    _1password-gui.enable = true;
    _1password-gui.polkitPolicyOwners = [ "rbjorklin" ];
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    waybar.enable = true;
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
  };

  # Required to get swaylock & swayidle on $PATH and for swaylock to register with pam.
  # https://github.com/nix-community/home-manager/pull/4416/files#diff-81ffdc4284f13266610da15d67b11e7b4d46e25c4ac59be3fd07be2dd56018a9R31
  # https://nix-community.github.io/home-manager/options.html#opt-programs.swaylock.enable
  security.pam.services.swaylock = {};

  services.gnome.gnome-settings-daemon.enable = true;

  users.users.rbjorklin = {
    packages = with pkgs; [
      alacritty
      copyq
      evince
      firefox
      gdk-pixbuf # nwg-look / GTK3 theming
      glib # nwg-look / GTK3 theming
      gnome.adwaita-icon-theme # https://nixos.wiki/wiki/GNOME#Running_GNOME_programs_outside_of_GNOME
      gnome.eog
      gnome.gnome-keyring
      gnome.nautilus
      grim # grab images from Wayland
      inotify-tools # dune build --watch
      unstable.nwg-look # GTK3 theming under Wayland
      polkit_gnome
      rPackages.fontawesome
      slurp # select a region in a Wayland compositor
      spotify
      wl-clipboard
      xorg.libxshmfence # 1password dep?
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
    gnome.gnome-control-center
    hyprland
    hyprpaper
    libnotify
    mako
    pciutils
    pulseaudio # volume control
    swayidle
    swaylock
    tofi
    unstable.monaspace
    waybar
    wayland
    wdisplays # configure displays
    xdg-utils # open default program when clicking link
  ];

  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
    LIBSEAT_BACKEND = "logind";
  };
}
