{
  config,
  pkgs,
  ...
}: let
  fullyQualifiedDomainName = "${config.networking.hostName}.${config.networking.domain}";
  clientConfig = {
    "m.homeserver".base_url = "https://${fullyQualifiedDomainName}";
    "m.identity_server" = {};
  };
  serverConfig = {
    "m.server" = "${fullyQualifiedDomainName}:443";
  };
  makeWellKnown = serverData: ''
    add_header Content-Type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON serverData}';
  '';
in {
  services.nginx = {
    enable = true;
    virtualHosts = {
      "${config.networking.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "= /.well-known/matrix/server".extraConfig = makeWellKnown serverConfig;
          "= /.well-known/matrix/client".extraConfig = makeWellKnown clientConfig;
        };
      };
      "${fullyQualifiedDomainName}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/".proxyPass = "http://[::1]:8008";
          "/_matrix".proxyPass = "http://[::1]:8008";
          "/_synapse/client".proxyPass = "http://[::1]:8008";
        };
      };
      "element.${fullyQualifiedDomainName}" = {
        enableACME = true;
        forceSSL = true;
        serverAliases = ["element.${config.networking.domain}"];

        root = pkgs.element-web.override {
          conf = {
            default_server_config = clientConfig;
          };
        };
      };
    };

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };
}
