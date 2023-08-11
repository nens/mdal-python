#!/usr/bin/env python3

import fileinput
import json

def extract_libs_to_ignore(raw_lddtree: str):
    raw_lddtree = raw_lddtree.lstrip("INFO:auditwheel.main_lddtree:")
    lddtree = json.loads(raw_lddtree)
    libs = lddtree["libs"].keys()
    libs_to_ignore = []
    for lib in libs:
        if "mdal" not in lib:
            libs_to_ignore.append(lib)
    libs_to_ignore_string = "".join([f" --exclude {lib}" for lib in libs_to_ignore])
    return libs_to_ignore_string

with fileinput.input() as f_input:
    data = "".join([line for line in f_input])
print(extract_libs_to_ignore(data))
