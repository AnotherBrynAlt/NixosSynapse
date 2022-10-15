{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {self, ...} @ inputs: let
    system = "x86_64-linux";
    nixpkgs = import inputs.nixpkgs {system = system;};
  in {
    colmena = {
      meta = {
        inherit nixpkgs;

        specialArgs = {
          inherit inputs;
        };
      };

      synapse = {
        imports = [./hosts/synapse];

        deployment = {
          keys = {
            "macaroon" = {
              group = "matrix-synapse";
              keyCommand = ["cat" "<(echo -en \"macaroon_secret_key: \")" "<(pwgen -s 64 1)"];
            };
          };
          privilegeEscalationCommand = ["doas"];
          tags = ["web" "matrix" "synapse"];
          targetHost = "2001:19f0:5401:1402:5400:4ff:fe2b:33aa";
          targetPort = 22;
          targetUser = "nixos";
        };
      };
    };

    devShells.${system}.default = nixpkgs.mkShell {
      buildInputs = with nixpkgs; [
        colmena
        pwgen
      ];
    };
  };
}
