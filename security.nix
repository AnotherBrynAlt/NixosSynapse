{ ... }:
{
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
          extraDomainNames = [ "matrix.bryn.top" "www.bryn.top" ];
        };
      };
    };
  };
  users.users.nginx.extraGroups = [ "matrix-synapse" ];
}

