#!/usr/bin/env bash

export PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}
export LD_LIBRARY_PATH=${PREFIX}/lib:${LD_LIBRARY_PATH}
export INCLUDE=${PREFIX}/include

mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_INSTALL_LIBDIR=${PREFIX}/lib -DCMAKE_INSTALL_INCLUDEDIR=${PREFIX}/include -DCMAKE_AR="${AR}" -DSPM_ENABLE_TCMALLOC=OFF -S ..

make -j $(nproc)

make install

if [[ "$target_platform" == linux* ]]; then
  ldconfig -v -N
elif [[ $target_platform == "osx-64" ]]; then
  update_dyld_shared_cache
fi

cd ../python

${PYTHON} -m pip install . -vv