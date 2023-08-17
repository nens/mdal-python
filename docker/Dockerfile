FROM ubuntu:jammy

LABEL py_version='3.x'

ARG DEBIAN_FRONTEND=noninteractive

VOLUME /dist
VOLUME /source-code

COPY requirements /

RUN apt-get update && apt-get install -y $(cat /requirements/apt_requirements.txt) && rm -rf /var/lib/apt/lists/*

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

RUN pip install -U pip setuptools

RUN pip install -r /requirements/pip_requirements.txt

ENV PIP_WHEEL_DIR=/wheeldir
ENV PIP_FIND_LINKS=/wheeldir

COPY scripts /
WORKDIR /scripts
RUN chmod +x *

WORKDIR /

ENTRYPOINT /scripts/docker_entrypoint.sh
