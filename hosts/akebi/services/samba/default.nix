{ pkgs, config, ... }:
{
  services.samba = {
    enable = true;
    openFirewall = true;
    extraConfig = ''
      # note: localhost is the ipv6 localhost ::1
      hosts allow = 192.168.1. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      memories = {
        path = "/data/networkshare/Pictures/Memories";
        comment = "Public samba share for memories.";
        browseable = "yes";
        "read only" = true;
        "guest ok" = "yes";
        "create mask" = "0444";
        "directory mask" = "0555";
      };
    };
  };
}

