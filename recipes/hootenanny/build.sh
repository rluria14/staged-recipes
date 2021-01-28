#!/usr/bin/env bash

### set HOOT_HOME
if [ -z "$HOOT_HOME" ]; then
    HOOT_HOME=~/hoot
fi
echo HOOT_HOME: $HOOT_HOME

### Temp change until we get the C++11 support into develop
cd $HOOT_HOME
cp LocalConfig.pri.orig LocalConfig.pri
echo "QMAKE_CXXFLAGS += -std=c++11" >> LocalConfig.pri

echo "SetupEnv.sh"
source ./SetupEnv.sh

echo "Building Hoot"
# Going to remove this so that it gets updated
if [ -f missing ]; then
  rm -f missing
fi

### configure
aclocal && autoconf && autoheader && automake --add-missing --copy

./configure \
  --with-rnd \
  --without-services \
  --without-postgresql \
  --prefix=/usr/ \
  --datarootdir=/usr/share/hootenanny/ \
  --docdir=/usr/share/doc/hootenanny/ \
  --localstatedir=/var/lib/hootenanny/ \
  --libdir=/usr/lib64 \
  --sysconfdir=/etc/

### build simple
make -s clean && make -sj$(nproc)

# This stops the install dieing if it cant copy PDF files.
touch docs/empty.pdf

