FROM ubuntu:jammy

LABEL py_version='3.x'

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    libgdal-dev \
    libhdf5-dev \
    libnetcdf-dev \
    libxml2-dev \
    python3-dev \
    python3-venv \
    g++ \
    cmake \
    git \
&& rm -rf /var/lib/apt/lists/*

# First fetch the code for MDAL and mdal-python

WORKDIR /

# using curl to download the zips is much faster than a simple git clone
RUN mkdir MDAL
RUN curl -Lo MDAL.tar.gz https://github.com/lutraconsulting/MDAL/archive/master.tar.gz && tar -xzf MDAL.tar.gz -C MDAL --strip-components=1

RUN mkdir python-mdal
RUN curl -Lo python-mdal.tar.gz https://github.com/ViRGIS-Team/mdal-python/archive/main.tar.gz && tar -xzf python-mdal.tar.gz -C python-mdal --strip-components=1

# Build MDAL
WORKDIR /MDAL/build
ARG CMAKE_INSTALL_PREFIX=/usr
RUN cmake -DCMAKE_BUILD_TYPE=Rel -DENABLE_TESTS=ON .. && make && cmake -P cmake_install.cmake

# Avoid issues with upgrading an apt-managed pip.
RUN curl -s https://bootstrap.pypa.io/get-pip.py | python3
RUN pip install -U pip

RUN pip install build

ENV PIP_WHEEL_DIR=/wheeldir
ENV PIP_FIND_LINKS=/wheeldir

VOLUME /dist

WORKDIR /python-mdal

ENTRYPOINT python3 -m build --wheel --outdir /dist

