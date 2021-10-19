{ autoPatchelfHook, fetchzip, lib, stdenv }:
stdenv.mkDerivation rec {
  name = "wasmtime";
  version = "0.30.0";
  src = fetchzip {
    x86_64-linux = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-x86_64-linux.tar.xz";
      hash =
        "sha512-qPeJz3tRiCEu4zsdiJ5j5IPIGtaluxXUtUlhk/8VWS2UrPukCxT6tMn9zQTsoBK/Ymia00jfgBstb4oBmhyrpQ==";
    };
    aarch64-linux = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-aarch64-linux.tar.xz";
      hash =
        "sha512-OuhEy2VFMFdSNT3TcnOeBDswqRRGfxqHghCeEdv+I7zPMnOvFjQP8iAtRpiuuREvcv6TVO54i91EQ2eTAZ842w==";
    };
    x86_64-darwin = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-x86_64-macos.tar.xz";
      hash =
        "sha512-/t2C9gSsASoOD9tsv3bGWlvBbm43hSlBM3FH7BRX3+3FoTPTjQTa1+NHcfHbnC50MbEG6lT7drGKVmqkZzF29w==";
    };
  }.${stdenv.hostPlatform.system};
  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  installPhase = ''
    mkdir -p $out/bin
    mv wasmtime $out/bin
  '';
  doInstallCheck = true;
  installCheckPhase = "$out/bin/wasmtime --version";
}
