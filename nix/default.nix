{ sources ? import ./sources.nix { }
, haskellNix ? import sources.haskell-nix { }
, pkgs ? import haskellNix.sources.nixpkgs-unstable { }
}:
import (if pkgs.stdenv.isLinux then ./linux.nix else ./darwin.nix) { }
