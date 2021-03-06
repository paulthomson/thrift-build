#!/bin/bash
set -x
set -e
set -u

rm -rf build-release || true
mkdir -p build-release/Linux
mkdir -p build-release/Windows

wget http://www-eu.apache.org/dist/thrift/0.10.0/thrift-0.10.0.tar.gz
tar -xvf thrift-*.tar.gz

cd linux-out
./build
cd ..

cd x86_64-w64-mingw32-out
./build
cd ..

cp linux-out/install/bin/thrift build-release/Linux/thrift
cp x86_64-w64-mingw32-out/install/bin/thrift.exe build-release/Windows/thrift.exe
cd build-release
zip -r ../thrift.zip *
cd ..
github-release \
  paulthomson/thrift-build \
  v-${CI_BUILD_REF} \
  ${CI_BUILD_REF} \
  "$(echo -e "Automated build.\n$(git log --graph -n 3 --abbrev-commit --pretty='format:%h - %s <%an>')")" \
  'thrift.zip'

