{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/123c88bcd0acd32c1d224187fd27cc9001b0e1a8";

    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        name = "simple";
        src = ./.;
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          # default = derivation {
          #   inherit system name src;
          #   builder = with pkgs; "${bash}/bin/bash";
          #   args = [ "-c" "echo foo > $out" ];
          # };
          # defaultPackage = self.packages.spanner-emulator;
        } // (if system == "x86_64-linux" then {
          spanner-emulator =
            let
              version = "1.5.2";
              inherit (pkgs) stdenv lib;
            in
            stdenv.mkDerivation rec
            {
              name = "spanner-emulator";
              src = pkgs.fetchurl {
                url =
                  "https://storage.googleapis.com/cloud-spanner-emulator/releases/${version}/cloud-spanner-emulator_linux_amd64-${version}.tar.gz";
                sha256 = "e02e53776f36865dd581234c0c21a54add77d88fb956023aa47f99d96c0af788";
              };
              # buildInputs = with pkgs; [
              #   stdenv.cc.cc.lib
              # ];
              # nativeBuildInputs = with pkgs; [
              #   autoPatchelfHook
              #   stdenv.cc.cc.lib
              # ];
              # phases = [ "unpackPhase" ];
              sourceRoot = ".";
              unpackPhase = ''
                mkdir -p $out/bin
                tar -xzf $src -C $out/bin
              '';
              dontConfigure = true;
              dontBuild = true;

              preFixUp =
                let
                  libPath = nixpkgs.lib.makeLibraryPath [
                    stdenv.cc.cc.lib
                  ];
                in
                ''
                  echo $libPath
                  patchelf \
                    --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                    --set-rpath "${libPath}" \
                    $out/bin/emulator_main
                '';

              meta = with nixpkgs.lib; {
                homepage = "https://github.com/GoogleCloudPlatform/cloud-spanner-emulator";
                description =
                  "Cloud Spanner Emulator is a local emulator for the Google Cloud Spanner database service.";
                platforms = platforms.linux;
              };
            };
        } else { });
        defaultPackage = self.packages.spanner-emulator;
      }
    );
}


