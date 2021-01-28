#!/usr/bin/env bash

source ./SetupEnv.sh

### configure
aclocal && autoconf && autoheader && automake && ./configure --with-services --with-uitests --with-rnd --with-coverage

### build simple
#./configure && make -j$(nproc)

### build complete
./configure --with-rnd --with-services && make -j$(nproc)

