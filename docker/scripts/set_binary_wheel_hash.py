"""
This script adds a file to a pip wheel RECORD, so that when pip installs
a wheel, it knows this file belongs with the package.

For more information information about the wheel RECORD, look at PEP 491,
specifically the section about the .dist-info directory.
https://peps.python.org/pep-0491/#the-dist-info-directory
"""

import hashlib
import base64
import argparse
from pathlib import Path

def add_file_to_record(filepath: Path, recordpath: Path):
    with filepath.open(mode='rb') as filehandler:
        filecontents = filehandler.read()
    hash = base64.urlsafe_b64encode(
        hashlib.sha256(filecontents).digest()
    ).decode('latin1').rstrip('=')
    bytecount = len(filecontents)
    
    wheel_path = recordpath.parents[1]  # "grandparent" of the RECORD file is the wheel root path
    filename = str(filepath.relative_to(wheel_path))
    with recordpath.open(mode='a', newline="\r\n") as f:
        f.write(f"{filename},sha256={hash},{bytecount}\n")

parser = argparse.ArgumentParser()
parser.add_argument('filename')
parser.add_argument('recordfile')

args = parser.parse_args()
filenamepath = Path(args.filename)
recordfilepath = Path(args.recordfile)
add_file_to_record(filenamepath, recordfilepath)
