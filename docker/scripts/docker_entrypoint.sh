#! /usr/bin/env sh
set -e

# copy source code from mountpoint to a temporary directory so we can write to it
mkdir /mdal-python
cd /mdal-python
cp -r /source-code/* .
# build it in a separate build directory
mkdir wheel_build
python3 -m build --wheel --outdir wheel_build
cd wheel_build
WHEEL_NAME=$(find . -name *.whl)
cd ..
# extract it for editing
mkdir extractedwheel
unzip wheel_build/mdal*.whl -d extractedwheel
cd extractedwheel
ls
mkdir mdal.libs
# copy in the MDAL binary, libmdal.so
cp /usr/local/lib/libmdal.so mdal.libs
DISTINFO_DIR=$(find . -name *.dist-info)
# add the MDAL binary to the pip wheel file record
python3 /scripts/set_binary_wheel_hash.py mdal.libs/libmdal.so $DISTINFO_DIR/RECORD
# allow the main libmdalpython binary to find the MDAL binary
patchelf --set-rpath '$ORIGIN'/../mdal.libs mdal/libmdalpython*.so
# zip the edited contents to a new wheel with the same name
zip -r $WHEEL_NAME *
# and copy it to the rw mount directory
cp $WHEEL_NAME /dist
