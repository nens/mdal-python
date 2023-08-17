mkdir /mdal-python
cd /mdal-python
cp -r /source-code/* .
mkdir wheel_build
python3 -m build --wheel --outdir wheel_build
cd wheel_build
WHEEL_NAME=$(find . -name *.whl)
cd ..
mkdir extractedwheel
unzip wheel_build/mdal_python*.whl -d extractedwheel
cd extractedwheel
mkdir mdal_python.libs
cp /usr/local/lib/libmdal.so mdal_python.libs
DISTINFO_DIR=$(find . -name *.dist-info)
python3 /scripts/set_binary_wheel_hash.py mdal_python.libs/libmdal.so $DISTINFO_DIR/RECORD
patchelf --set-rpath '$ORIGIN'/../mdal_python.libs mdal/libmdalpython*.so
zip -r $WHEEL_NAME *
cp $WHEEL_NAME /dist
