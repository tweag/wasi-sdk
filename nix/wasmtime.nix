{ autoPatchelfHook, fetchzip, lib, stdenv }:
stdenv.mkDerivation rec {
  name = "wasmtime";
  version = "0.31.0";
  src = fetchzip {
    x86_64-linux = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-x86_64-linux.tar.xz";
      hash =
        "sha512-AxuCYi9IUGmM1kT1uyii8ncY9VeMW7FPAktJmHfqfLeYNc2+ZyR0l1sBwfWDm4nNokOhJ6uLDBrbOmwb1C2AQQ==";
    };
    aarch64-linux = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-aarch64-linux.tar.xz";
      hash =
        "sha512-+vkehh8eLcJ0QLlxU/665ers09GeXhllV0idU4sjfiX/lGDxqK4tQkOBRjDFVz0+QRSvXRoatSeJWj7ujTo6fQ==";
    };
    x86_64-darwin = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-x86_64-macos.tar.xz";
      hash =
        "sha512-ArdebSk1GFraFqb6fJxxSdprQYr6vzsJgInWjhpqzk0/fFnF9iNEPw94yylNOnhoqngHrow+0BDcb8/i0GUrzw==";
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
