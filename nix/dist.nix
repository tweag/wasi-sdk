{ sources ? import ./sources.nix { }, pkgs ? import sources.nixpkgs { } }:
pkgs.callPackage
  ({ runCommand, zstd }:
    runCommand "wasi-sdk-dist" { nativeBuildInputs = [ zstd ]; }
      "tar -c --sort=name --mtime=0 --owner=0 --group=0 --numeric-owner -C ${
    import ./default.nix { }
  } . | zstd -T$NIX_BUILD_CORES --ultra -22 -o $out")
{ }
