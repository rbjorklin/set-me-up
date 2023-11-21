{ config, pkgs, lib, ... }:

{
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
}
