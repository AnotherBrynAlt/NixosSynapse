{
  config,
  pkgs,
  distributorUser,
  ...
}: {
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./security.nix

    ./services/matrix.nix
    ./services/nginx.nix
    ./services/openssh.nix
    ./services/postgresql.nix
  ];

  users.users.${distributorUser} = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOBDGkggZqAPjUEtzl5tJLLLOh8OMElRYSTZqUNnYENH bryn"
    ];
  };

  nix = {
    trustedUsers = ["${distributorUser}"];
  };

  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "22.05";
}
