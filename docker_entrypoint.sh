mkdir wheel_build
python3 -m build --wheel --outdir wheel_build
mkdir extractedwheel
cd extractedwheel
cp ../wheel_build/mdal_python*.whl mdal_python_wheel.zip
unzip mdal_python_wheel.zip
IGNORELIBS=(auditwheel lddtree ./extractedwheel/mdal/libmdalpython.*.so 2> >(../extract_libs_to_ignore.py))
cd ..
auditwheel repair --plat linux_x86_64 $IGNORELIBS wheel_build/mdal_python*.whl --wheel-dir /dist
