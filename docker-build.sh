#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
GIT_SUBMODULE="helium-chromium"

IMAGE="chromium-builder:bullseye"

echo "building docker image '${IMAGE}'"
(cd $BASE_DIR/docker && docker buildx build -t ${IMAGE} -f ./build.Dockerfile .)

# checkout helium-chromium submodule if not present
[ -n "$(ls -A ${BASE_DIR}/${GIT_SUBMODULE})" ] || git submodule update --init --recursive

# execute build.sh within docker container
BUILD_START=$(date)
echo "docker build start at ${BUILD_START}"

cd ${BASE_DIR} && docker run -it -v ${BASE_DIR}:/repo ${IMAGE} /bin/bash -c "/repo/build.sh $@"

BUILD_END=$(date)
echo -e " => docker build start at ${BUILD_START}"
echo -e " =>                end at ${BUILD_END}"

