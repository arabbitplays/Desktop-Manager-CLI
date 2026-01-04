{
  description = "DesktopManagerCLI flake with devShell and build derivation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }: let
    systems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in
  {
    # Development shells
    devShells = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        default = pkgs.mkShell {
          packages = with pkgs; [];

          buildInputs = with pkgs; [
            meson
            ninja
            pkg-config
            python3
          ];

          shellHook = ''
            echo "Entered DesktopManagerCLI dev environment for ${system}"
          '';
        };
      }
    );

    # Packages / build derivation
    packages = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        desktop-manager-cli = pkgs.stdenv.mkDerivation {
          pname = "DesktopManagerCLI";
          version = "1.0.0";

          src = self;

          nativeBuildInputs = with pkgs; [
            meson
            ninja
            pkg-config
          ];

          buildInputs = with pkgs; [
            python3
          ];
        };
      }
    );

    # Default package for `nix run .`
    defaultPackage = self.packages.${builtins.currentSystem}.desktop-manager-cli;
  };
}
