FROM ubuntu:jammy

LABEL py_version='3.x'

ARG DEBIAN_FRONTEND=noninteractive

VOLUME /dist
VOLUME /source-code

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
    unzip \
    zip \
&& rm -rf /var/lib/apt/lists/*

# First fetch the code for MDAL and mdal-python

WORKDIR /

ARG MDALVERSION=release-1.0.3

# using curl to download the zips is much faster than a simple git clone
RUN curl -Lo MDAL.tar.gz https://github.com/lutraconsulting/MDAL/archive/refs/tags/${MDALVERSION}.tar.gz && \
    tar -xzf MDAL.tar.gz && \
    rm MDAL.tar.gz && \
    mv MDAL-${MDALVERSION} MDAL

# Build MDAL
WORKDIR /MDAL/build
RUN cmake -DCMAKE_BUILD_TYPE=Rel -DENABLE_TESTS=ON .. && make && cmake --install .

# Avoid issues with upgrading an apt-managed pip.
RUN curl -s https://bootstrap.pypa.io/get-pip.py | python3
RUN pip install -U pip

RUN pip install build patchelf

ENV PIP_WHEEL_DIR=/wheeldir
ENV PIP_FIND_LINKS=/wheeldir

RUN mkdir -p /scripts
COPY docker_entrypoint.sh set_binary_wheel_hash.py /scripts/
WORKDIR /scripts
RUN chmod +x docker_entrypoint.sh

WORKDIR /

ENTRYPOINT /scripts/docker_entrypoint.sh
