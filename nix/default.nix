{ sources ? import ./sources.nix { }, pkgs ? import sources.nixpkgs { } }:
import (if pkgs.stdenv.isLinux then ./linux.nix else ./darwin.nix) { }
