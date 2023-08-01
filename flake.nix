{
  description = "Test C Script";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        buildInputs = [ pkgs.cmake ];
      in
      {
        formatter = pkgs.nixpkgs-fmt;
        packages = with pkgs; {
          default = stdenv.mkDerivation {
            inherit buildInputs;
            name = "test";
            src = ./.;
            configurePhase = ''
              ls -la
              cmake .
            '';
            buildPhase = ''
              make
            '';
            installPhase = ''
              mkdir -p $out/bin
              cp test $out/bin
            '';

          };
        };
      });
}
