{
  description = "Enhanced nix-darwin system flake with Conda";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    username = "naveedwani";

    configuration = { pkgs, config, ... }: {
      nixpkgs.config.allowUnfree = true;

      # System packages (added `tmux` and `neovim`) 
      environment.systemPackages = [
        pkgs.zsh
        pkgs.zsh-autosuggestions
        pkgs.zsh-syntax-highlighting
        pkgs.tmux
        pkgs.neovim
        pkgs.zsh-powerlevel10k
        pkgs.micromamba # Lightweight conda alternative managed by nix
      ];

      # Primary user
      system.primaryUser = "${username}";
      users.users."${username}".shell = pkgs.zsh;

      # Fonts
      fonts.packages = [ pkgs.nerd-fonts.meslo-lg ];

      # Zsh configuration (uses GitHub source for Powerlevel10k)
      environment.etc."zshrc".text = ''
        # Zsh plugins
        source "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
        source "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

        # Powerlevel10k theme
        source "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"

        # Set up micromamba (managed by nix)
        export MAMBA_ROOT_PREFIX="$HOME/.micromamba"
        export MAMBA_EXE="${pkgs.micromamba}/bin/micromamba"
        
        # Source micromamba setup only if .zshrc doesn't already have it
        if ! grep -q "mamba initialize" "$HOME/.zshrc"; then
          if [ ! -d "$MAMBA_ROOT_PREFIX" ]; then
            mkdir -p "$MAMBA_ROOT_PREFIX"
          fi
          
          # Setup micromamba hook directly without modifying .zshrc
          __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
          if [ $? -eq 0 ]; then
            eval "$__mamba_setup"
          else
            alias micromamba="$MAMBA_EXE"
          fi
          unset __mamba_setup
        fi
        
        # Add micromamba to path
        export PATH="${pkgs.micromamba}/bin:$PATH"
        
        # Helper function for creating ML environments
        create_ml_env() {
          local envname="$1"
          if [ -z "$envname" ]; then
            echo "Please provide an environment name"
            return 1
          fi
          
          echo "Creating ML environment: $envname"
          ${pkgs.micromamba}/bin/micromamba create -n "$envname" -c conda-forge python=3.10 -y
          ${pkgs.micromamba}/bin/micromamba install -n "$envname" -c conda-forge numpy pandas scikit-learn jupyter -y
          echo "Environment created. Activate with: micromamba activate $envname"
        }
        
        # Instructions for first use
        if [ ! -d "$MAMBA_ROOT_PREFIX/envs" ]; then
          echo "============================================================"
          echo "Micromamba is installed and managed by nix."
          echo "To create a new environment for ML projects, run:"
          echo ""
          echo "create_ml_env myenv"
          echo ""
          echo "To activate an environment:"
          echo "micromamba activate myenv"
          echo ""
          echo "To install packages:"
          echo "micromamba install -n myenv -c conda-forge tensorflow"
          echo "============================================================"
        fi
      '';

      # Application symlinks
      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
        '';	

      # Nix configuration
      nix.settings.experimental-features = "nix-command flakes";
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."air" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = { 
            enable = true;
            enableRosetta = true;
            user = "naveedwani";
          };
        }
      ];
    };
    darwinPackages = self.darwinConfigurations."air".pkgs;
  };
}