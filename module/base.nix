{ config, pkgs, lib, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "net.ipv6.conf.all.disable_ipv6" = 1;
  };

  # use systemd-networkd instead
  networking.dhcpcd.enable = false;
  systemd.network.enable = true;

  console = {
    keyMap = "colemak";
  };

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

  documentation.man = {
    enable = true;
    generateCaches = true;
  };

  programs = {
    zsh = {
      enable = true;
    };
  };

  nix = {
    optimise.automatic = true;
    gc.automatic = true;
    gc.options = "--delete-older-than 14d";
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
  nixpkgs.config.allowUnfree = true;

  users.users.rbjorklin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      bcc # # https://github.com/iovisor/bcc
      clusterctl
      cmake
      containerd
      ctags
      curl
      d2
      direnv
      fd
      fzf
      gcc
      git
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
      nmap
      opam
      packer
      patchelf # because NixOS does things its own way
      postgresql.lib # This should be libpq but see: https://github.com/NixOS/nixpkgs/issues/61580
      pv
      reptyr
      ripgrep
      rr
      shellcheck
      sops
      sqlite # zsh-histdb
      starship
      strace
      sysstat # provides iostat
      tldr
      tree
      vmtouch
      yq
      zip
      zsh
      zstd # OCaml 5.1.0
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search curl
  environment.systemPackages = with pkgs; [
    age
    file
    hdparm
    home-manager
    htop
    neovim
    nix-index
    parted
    pciutils
    tmux.tmux
    unzip
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.autoUpgrade.enable = true;
}
