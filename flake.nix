{
  description = "Nix darwin for backend dev";

  # Inputs: External dependencies this flake uses (other flakes, repos, etc.)
  inputs = {
    # nixpkgs: The main Nix package repository, using unstable branch for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # nix-darwin: Provides macOS system configuration capabilities (like NixOS but for macOS)
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      # "follows" ensures nix-darwin uses the SAME nixpkgs version as this flake (prevents version conflicts)
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager: Manages user-level configurations (dotfiles, user packages, etc.)
    home-manager = {
      url = "github:nix-community/home-manager";
      # Again, ensures same nixpkgs version to prevent conflicts
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Outputs: What this flake produces/exposes (configurations, packages, etc.)
  outputs =
    {
      # self: Reference to this flake itself
      self,
      # These are the inputs we defined above, now available as parameters
      nixpkgs,
      nix-darwin,
      home-manager,
      # ... catches any other inputs we might add later
      ...
    }:
    # let...in: Define helper functions and variables before the main outputs
    let
      # Package sets helper function
      mkPkgs =
        # Takes a system architecture (like "aarch64-darwin")
        system:
        # Import nixpkgs with specific configuration for that system
        import nixpkgs {
          # Pass the system architecture to nixpkgs
          inherit system;
          # Allow proprietary/unfree packages (like Slack, Chrome, etc.)
          config.allowUnfree = true;
        };

      # Helper function to create Darwin (macOS) system configurations
      mkDarwinSystem =
        {
          # Required: system architecture (aarch64-darwin, x86_64-darwin)
          system,
          # Required: username for the primary user
          username,
        }:
        # Use nix-darwin's library function to create a system configuration
        nix-darwin.lib.darwinSystem {
          # Pass system architecture to nix-darwin
          inherit system;
          # Special arguments passed to all modules in this configuration
          specialArgs = {
            # Make username available to all modules
            inherit username;
            # Make all flake inputs available to modules
            inputs = self.inputs;
            # Make the package set available to modules
            pkgs = mkPkgs system;
          };
          # List of modules that define the system configuration
          modules = [
            # Load Darwin-specific configuration from local modules
            ./modules/platforms/darwin/system

            # Include home-manager as a Darwin module (integrates user config with system config)
            home-manager.darwinModules.home-manager
            {
              # Configure home-manager integration
              home-manager = {
                # Use system-wide package set (more efficient, prevents duplicates)
                useGlobalPkgs = true;
                # Install packages to system profile instead of user profile
                useUserPackages = true;
                # Configure home-manager for the specified user
                users.${username} = import ./modules/platforms/darwin/home;
                # Pass extra arguments to home-manager modules
                extraSpecialArgs = {
                  inherit username;
                  inputs = self.inputs;
                };
                # When home-manager conflicts with existing files, backup with .backup extension
                backupFileExtension = "backup";
              };
            }
          ];
        };

      # Helper function to create standalone home-manager configurations (for Linux)
      mkHomeConfiguration =
        {
          # Same parameters as Darwin helper
          system,
          username,
        }:
        # Use home-manager's library function to create user configuration
        home-manager.lib.homeManagerConfiguration {
          # Create package set for this system
          pkgs = mkPkgs system;
          # Load Linux-specific home configuration modules
          modules = [ ./modules/platforms/linux ];
          # Pass extra arguments to home-manager modules
          extraSpecialArgs = {
            inherit username;
            inputs = self.inputs;
          };
        };
      # in: The actual outputs this flake provides
    in
    {
      # Darwin configurations - These are what 'darwin-rebuild' looks for
      darwinConfigurations = {
        # Default configuration - uses current system architecture
        # Usage: darwin-rebuild switch --flake .#default --impure
        default = mkDarwinSystem {
          # builtins.currentSystem auto-detects your Mac's architecture
          system = builtins.currentSystem;
          username = "your-username";
        };

        # ARM64 macOS configuration (Apple Silicon Macs)
        # Usage: darwin-rebuild switch --flake .#aarch64-darwin
        aarch64-darwin = mkDarwinSystem {
          system = "aarch64-darwin";
          username = "your-username";
        };

        # Intel macOS configuration (Intel Macs)
        # Usage: darwin-rebuild switch --flake .#x86_64-darwin
        x86_64-darwin = mkDarwinSystem {
          system = "x86_64-darwin";
          username = "your-username";
        };
      };

      # Home Manager configurations - For Linux systems or standalone user configs
      homeConfigurations = {
        # Linux ARM64 configuration (like Raspberry Pi, ARM servers)
        # Usage: home-manager switch --flake .#aarch64-linux
        aarch64-linux = mkHomeConfiguration {
          system = "aarch64-linux";
          username = "your-username";
        };

        # Linux x86_64/AMD64 configuration (most Linux desktops/servers)
        # Usage: home-manager switch --flake .#x86_64-linux
        x86_64-linux = mkHomeConfiguration {
          system = "x86_64-linux";
          username = "your-username";
        };
      };
    };
}
