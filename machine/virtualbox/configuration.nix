# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, ... }:

{
  networking.hostName = "nixos";

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/base.nix
      ../../modules/desktop-environment.nix
      ../../modules/virtualbox.nix
      ../../modules/etc-issue.nix # Toy example of build vs. runtime configuration
    ];

  hardware = {
    opengl.enable = true;
  };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
