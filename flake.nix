{
  description = "Nix darwin for backend dev";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      # Auto-detect the invoking user (SUDO_USER when run via `sudo darwin-rebuild`,
      # else USER). Requires --impure.
      autoUsername =
        let
          sudoUser = builtins.getEnv "SUDO_USER";
          user = builtins.getEnv "USER";
        in
        if sudoUser != "" then
          sudoUser
        else if user != "" then
          user
        else
          throw "Neither $SUDO_USER nor $USER is set — can't auto-detect the username. Run with --impure in a normal shell.";

      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
        };

      mkDarwinSystem =
        {
          system,
          username,
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit username;
            inputs = self.inputs;
            pkgs = mkPkgs system;
          };
          modules = [
            ./modules/platforms/darwin/system

            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = import ./modules/platforms/darwin/home;
                extraSpecialArgs = {
                  inherit username;
                  inputs = self.inputs;
                };
                backupFileExtension = "backup";
              };
            }
          ];
        };

      mkHomeConfiguration =
        {
          system,
          username,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;
          modules = [ ./modules/platforms/linux ];
          extraSpecialArgs = {
            inherit username;
            inputs = self.inputs;
          };
        };
    in
    {
      darwinConfigurations = {
        default = mkDarwinSystem {
          system = builtins.currentSystem;
          username = autoUsername;
        };

        aarch64-darwin = mkDarwinSystem {
          system = "aarch64-darwin";
          username = autoUsername;
        };

        x86_64-darwin = mkDarwinSystem {
          system = "x86_64-darwin";
          username = autoUsername;
        };
      };

      homeConfigurations = {
        aarch64-linux = mkHomeConfiguration {
          system = "aarch64-linux";
          username = autoUsername;
        };

        x86_64-linux = mkHomeConfiguration {
          system = "x86_64-linux";
          username = autoUsername;
        };
      };
    };
}
