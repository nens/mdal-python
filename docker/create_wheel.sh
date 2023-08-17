docker build --tag "mdal-python" .
docker run --rm -v "$(pwd)":/source-code:ro -v "$(pwd)"/dist:/dist mdal-python
