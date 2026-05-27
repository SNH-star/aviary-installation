#!/bin/bash

set -e

export AVIARY_VERSION=$1
echo "Testing Aviary version $AVIARY_VERSION"

# Download test data
echo "Downloading test data .."
wget --quiet https://github.com/rhysnewell/aviary/raw/main/test/data/wgsim.1.fq.gz -O wgsim.1.fq.gz
wget --quiet https://github.com/rhysnewell/aviary/raw/main/test/data/wgsim.2.fq.gz -O wgsim.2.fq.gz

# Test conda install
echo "Testing conda install .."
sed "s/AVIARY_VERSION/$AVIARY_VERSION/g" Dockerfile.conda.in > Dockerfile.conda
docker build --no-cache --progress=plain -f Dockerfile.conda . &> conda.build.log

# Test PyPI install
echo "Testing PyPI install .."
sed "s/AVIARY_VERSION/$AVIARY_VERSION/g" Dockerfile.pypi.in > Dockerfile.pypi
docker build --no-cache --progress=plain -f Dockerfile.pypi . &> pypi.build.log

# Test docker install
echo "Testing docker aviary .."
chmod g+rw .
bash -c "docker pull wwood/aviary:$AVIARY_VERSION && docker run -v \`pwd\`:/data wwood/aviary:$AVIARY_VERSION assemble \
    -1 /data/wgsim.1.fq.gz \
    -2 /data/wgsim.2.fq.gz \
    --use-megahit \
    --skip-qc \
    -o /data/aviary_docker_out \
    -n 4 -t 4" &> docker.build.log

# Test apptainer install
echo "Testing apptainer aviary .."
rm -f aviary_$AVIARY_VERSION.sif
bash -c "apptainer pull docker://wwood/aviary:$AVIARY_VERSION && apptainer run --cleanenv -B \`pwd\`:\`pwd\` aviary_$AVIARY_VERSION.sif assemble \
    -1 \`pwd\`/wgsim.1.fq.gz \
    -2 \`pwd\`/wgsim.2.fq.gz \
    --use-megahit \
    --skip-qc \
    -o \`pwd\`/aviary_apptainer_out \
    -n 4 -t 4" > apptainer.build.stdout.log 2> apptainer.build.stderr.log

echo "All installation methods tested successfully."
