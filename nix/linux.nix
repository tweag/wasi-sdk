{ sources ? import ./sources.nix { }
, haskellNix ? import sources.haskell-nix { }
, pkgs ? import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs
}:
pkgs.pkgsCross.musl64.callPackage
  ({ binaryen
   , cmake
   , haskell-nix
   , llvmPackages_13
   , ninja
   , python3
   , writeShellScriptBin
   }:
    llvmPackages_13.stdenv.mkDerivation {
      name = "wasi-sdk";
      src = haskell-nix.haskellLib.cleanGit {
        name = "wasi-sdk-src";
        src = ../.;
      };
      patches = [ ./wasi-sdk.diff ];
      postPatch = "patchShebangs tests ./*.sh";
      dontConfigure = true;
      hardeningDisable = [ "all" ];
      nativeBuildInputs = [
        binaryen
        cmake
        llvmPackages_13.lld
        ninja
        python3
        (writeShellScriptBin "strip" ''exec $STRIP "$@"'')
        (pkgs.callPackage ./wasmtime.nix { })
      ];
      buildPhase = "NINJA_FLAGS=-j$NIX_BUILD_CORES make build strip";
      installPhase = ''
        mv build/install/opt/wasi-sdk $out
        env CC=$out/bin/clang CXX=$out/bin/clang++ HOME=$(mktemp -d) tests/run.sh wasmtime
      '';
      dontFixup = true;
      allowedReferences = [ ];
    })
{ }
