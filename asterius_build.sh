#!/bin/bash

set -euo pipefail

apt update
apt full-upgrade -y
apt install -y \
  cmake \
  curl \
  ninja-build

curl https://apt.llvm.org/llvm-snapshot.gpg.key -o /etc/apt/trusted.gpg.d/llvm.asc
echo "deb http://apt.llvm.org/unstable/ llvm-toolchain main" > /etc/apt/sources.list.d/llvm.list
apt update
apt full-upgrade -y
apt install -y \
  clang-11 \
  lld-11

make package
