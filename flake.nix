{
  description = "Flake packaging the wtftw window manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    wtftw = {
      url = "github:Kintaro/wtftw";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, wtftw }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in with pkgs;
      with xorg; rec {
        packages.wtftw = rustPlatform.buildRustPackage {
          pname = "wtftw";
          version = "0.4.4";
          src = wtftw;
          cargoHash = "sha256-JXH+JWM58dwG+i8g4ANLY3WL9lQ/pcOfyEao5qxs9wk=";
          nativeBuildInputs = [ pkg-config makeWrapper ];
          buildInputs = [ libXinerama libX11 ];
          libPath = lib.makeLibraryPath [ libXinerama libX11 ];
        };

        packages.default = packages.wtftw;
      });
}
