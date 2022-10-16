{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, ...} @ inputs: let
    distributorUser = "nixos";
    system = "x86_64-linux";
    nixpkgs = import inputs.nixpkgs {system = system;};
  in {
    colmena = {
      meta = {
        inherit nixpkgs;

        specialArgs = {
          inherit inputs distributorUser;
        };
      };

      synapse = {
        imports = [
          inputs.sops-nix.nixosModules.sops
          ./hosts/synapse
        ];

        sops.defaultSopsFile = ./secrets/secrets.yaml;
        sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        sops.secrets = {
          email = {};
          "matrix-appservice-discord.env" = {};
          matrix-shared-secret = {};
        };

        deployment = {
          privilegeEscalationCommand = ["doas"];
          tags = ["web" "matrix" "synapse"];
          targetHost = "2001:19f0:5401:1402:5400:4ff:fe2b:33aa";
          targetPort = 22;
          targetUser = distributorUser;
        };
      };
    };

    devShells.${system}.default = nixpkgs.mkShell {
      buildInputs = with nixpkgs; [
        colmena
        sops
      ];
    };
  };
}
