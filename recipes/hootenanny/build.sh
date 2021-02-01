#!/usr/bin/env bash

#### set HOOT_HOME
#if [ -z "$HOOT_HOME" ]; then
#    HOOT_HOME=~/hoot
#fi
#echo HOOT_HOME: $HOOT_HOME
#
#### Temp change until we get the C++11 support into develop
#cd $HOOT_HOME

echo "SetupEnv.sh"
source ./SetupEnv.sh

# Going to remove this so that it gets updated
if [ -f missing ]; then
  rm -f missing
fi
echo "PYTHON VERSION CHECK CHECK CHECK : '%u.%u' % ${PY_VER}[:2]"


### configure
aclocal && autoconf && autoheader && automake --add-missing --copy

./configure \
  --with-rnd \
  --with-services \
  --with-coverage \
  --with-uitests \
  PYTHON_VERSION="'%u.%u' % ${PY_VER}[:2]" \
  PYTHON_NOVERSIONCHECK="True"


if [ ! -f LocalConfig.pri ] && ! grep --quiet QMAKE_CXX LocalConfig.pri; then
    echo 'Customizing LocalConfig.pri...'
    cp LocalConfig.pri.orig LocalConfig.pri
    sed -i s/"QMAKE_CXX=g++"/"#QMAKE_CXX=g++"/g LocalConfig.pri
    sed -i s/"#QMAKE_CXX=ccache g++"/"QMAKE_CXX=ccache g++"/g LocalConfig.pri
    if [ "$BUILD_DEBUG" == "yes" ]; then
        echo 'Building in DEBUG mode...'
        sed -i s/"CONFIG += release"/"#CONFIG += release"/ LocalConfig.pri
        sed -i s/"CONFIG -= debug"/"#CONFIG -= debug"/ LocalConfig.pri
        sed -i s/"#CONFIG += debug"/"CONFIG += debug"/ LocalConfig.pri
        sed -i s/"#CONFIG -= release"/"CONFIG -= release"/ LocalConfig.pri
    fi
fi

echo "Building Hoot"
### build
make -s clean && make -sj$(nproc)

