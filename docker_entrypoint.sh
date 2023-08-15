mkdir wheel_build
python3 -m build --wheel --outdir wheel_build
mkdir extractedwheel
unzip wheel_build/mdal_python*.whl -d extractedwheel
IGNORELIBS=$(auditwheel lddtree ./extractedwheel/mdal/libmdalpython.*.so 2>&1 >/dev/null | (./extract_libs_to_ignore.py))
auditwheel repair --plat linux_x86_64 $IGNORELIBS wheel_build/mdal_python*.whl --wheel-dir /dist
