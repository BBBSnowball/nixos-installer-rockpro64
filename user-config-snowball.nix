{ config, pkgs, ... }:
{
  networking.localCommands = ''
    ${pkgs.ethtool}/bin/ethtool -K eth0 rx off tx off
  '';
  networking.useDHCP = true;
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keyFiles = [ ./ssh-key.pub ];
}
