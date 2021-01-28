#!/usr/bin/env bash

export CXXFLAGS="${CXXFLAGS} -std=c++11"

### configure
aclocal && autoconf && autoheader && automake && ./configure --with-services --with-uitests --with-rnd --with-coverage

### build simple
#./configure && make -j$(nproc)

### build complete
./configure --with-rnd --with-services && make -j$(nproc)

