#! /usr/bin/env sh
set -e

CURRENTDIR=$(basename "$PWD")

if [ $CURRENTDIR != "docker" ]; then
    if [ $CURRENTDIR = "mdal-python" ]; then
        cd docker
    else
        echo "Could not find mdal-python or docker directory, please cd into one of those and try again."; exit 2
    fi
fi

docker build --tag "mdal-python" .
docker run --rm -v "$PWD"/..:/source-code:ro -v "$PWD"/../dist:/dist mdal-python
echo "Wheel has been written to ${PWD%/*}/dist"
