{ sources ? import ./sources.nix { }
, haskellNix ? import sources.haskell-nix { }
, pkgs ? import sources.nixpkgs haskellNix.nixpkgsArgs
}:
pkgs.callPackage
  ({ binaryen, cmake, gcc11Stdenv, haskell-nix, ninja, python3 }:
    gcc11Stdenv.mkDerivation {
      name = "wasi-sdk";
      src = haskell-nix.haskellLib.cleanGit {
        name = "wasi-sdk-src";
        src = ../.;
      };
      postPatch = "patchShebangs tests ./*.sh";
      dontConfigure = true;
      hardeningDisable = [ "all" ];
      nativeBuildInputs =
        [ binaryen cmake ninja python3 (pkgs.callPackage ./wasmtime.nix { }) ];
      buildPhase = "NINJA_FLAGS=-j$NIX_BUILD_CORES make build strip";
      installPhase = "mv build/install/opt/wasi-sdk $out";
      doInstallCheck = true;
      installCheckPhase = ''
        env CC=$out/bin/clang CXX=$out/bin/clang++ HOME=$(mktemp -d) tests/run.sh wasmtime
      '';
      dontFixup = true;
      strictDeps = true;
    })
{ }
