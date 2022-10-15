{distributorUser, ...}: {
  security = {
    acme = {
      acceptTerms = true;
      defaults = {
        email = "bryn.discord@gmail.com";
      };
      certs = {
        "bryn.top" = {
          group = "matrix-synapse";
          postRun = "systemctl reload nginx.service; systemctl restart matrix-synapse.service";
          extraDomainNames = ["matrix.bryn.top" "www.bryn.top"];
        };
      };
    };

    doas = {
      enable = true;
      extraRules = [
        {
          users = ["${distributorUser}"];
          keepEnv = true;
          noPass = true;
        }
      ];
    };

    sudo.enable = false;
  };
  users.users.nginx.extraGroups = ["matrix-synapse"];
}
