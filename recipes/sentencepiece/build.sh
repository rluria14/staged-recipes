#!/usr/bin/env bash

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} .. -DSPM_BUILD_TEST=ON -DSPM_ENABLE_TENSORFLOW_SHARED=ON -DCMAKE_AR=$GCC_AR -DSPM_USE_BUILTIN_PROTOBUF=OFF
make -j $(nproc)

export PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig:${PKG_CONFIG_PATH}
export LD_LIBRARY_PATH=${PREFIX}/lib:${LD_LIBRARY_PATH}
make install


#if [[ "$target_platform" == linux* ]]; then
#  make -j $(nproc)
#elif [[ $target_platform == "osx-64" ]]; then
#  make -j $(sysctl -n hw.logicalcpu)
#fi
#
#make install
#
#if [[ "$target_platform" == linux* ]]; then
#  ldconfig -v -N
#elif [[ $target_platform == "osx-64" ]]; then
#  update_dyld_shared_cache
#fi

cd ../python

python setup.py install