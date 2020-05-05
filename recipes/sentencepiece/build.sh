#!/usr/bin/env bash

export PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}
export LD_LIBRARY_PATH=${PREFIX}/lib:${LD_LIBRARY_PATH}

mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_INSTALL_LIBDIR=${PREFIX}/lib -DCMAKE_AR="${AR}" -DSPM_ENABLE_TCMALLOC=OFF -S ..

if [[ "$target_platform" == linux* ]]; then
  make -j $(nproc)
elif [[ $target_platform == "osx-64" ]]; then
  alias nproc="sysctl -n hw.logicalcpu"
  make -j $(nproc)
fi

make install

if [[ "$target_platform" == linux* ]]; then
  ldconfig -v -N
elif [[ $target_platform == "osx-64" ]]; then
  update_dyld_shared_cache
fi

cd ../python

${PYTHON} -m pip install . -vv