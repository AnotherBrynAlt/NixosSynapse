{...}: {
  networking = {
    hostName = "matrix";
    domain = "bryn.top";
    firewall = {
      enable = true;
      allowedTCPPorts = [22 80 443 8448];
    };
  };
}
