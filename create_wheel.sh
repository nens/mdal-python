docker build --tag "mdal-python" .
docker run --rm -v "$(pwd)"/docker_dist:/dist mdal-python