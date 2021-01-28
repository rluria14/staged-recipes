#!/usr/bin/env bash

source ./SetupEnv.sh

### configure
aclocal && autoconf && autoheader && automake --add-missing && ./configure --with-services --with-uitests --with-rnd --with-coverage

### build simple
./configure && make -sj$(nproc)

### build complete
#./configure --with-rnd --with-services && make -j$(nproc)

