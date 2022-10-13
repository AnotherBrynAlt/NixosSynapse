{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./matrix.nix
      ./networking.nix
      ./nginx.nix
      ./openssh.nix
      ./postgresql.nix
      ./security.nix
      ./systemd.nix
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

  users.users.nixos = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [ "wheel" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOBDGkggZqAPjUEtzl5tJLLLOh8OMElRYSTZqUNnYENH bryn"
    ];
  };

  system.stateVersion = "22.05";
}

