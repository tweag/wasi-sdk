#!/bin/bash

set -euo pipefail

apt update
apt full-upgrade -y
apt install -y \
  build-essential \
  cmake \
  git \
  ninja-build \
  python3

make package
