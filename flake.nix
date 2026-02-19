{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        deps = with pkgs; [
          zig
          bash
          libx11
          libxrandr
          libxi
          libxinerama
          libxcursor
          mesa
          libGL
          glfw
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          name = "Cubyz";
          packages = deps;
          shellHook = ''
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${builtins.toString (pkgs.lib.makeLibraryPath deps)}";
          '';
        };
      }
    );
}
