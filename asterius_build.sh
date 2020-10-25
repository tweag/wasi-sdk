#!/bin/bash

set -euo pipefail

apt update
apt full-upgrade -y
apt install -y \
  build-essential \
  ninja-build

make package
