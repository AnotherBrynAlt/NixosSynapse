{
  config,
  pkgs,
  distributorUser,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./security.nix

    ./services/matrix.nix
    ./services/nginx.nix
    ./services/openssh.nix
    ./services/postgresql.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "/dev/vda";
      };
    };
  };

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.${distributorUser} = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = ["wheel"];
    packages = with pkgs; [pwgen];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOBDGkggZqAPjUEtzl5tJLLLOh8OMElRYSTZqUNnYENH bryn"
    ];
  };

  nix = {
    trustedUsers = ["${distributorUser}"];
  };

  system.stateVersion = "22.05";
}
