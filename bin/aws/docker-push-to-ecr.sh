#!/bin/bash
set -e -o pipefail

# awscli is already installed in base docker image
$(aws ecr get-login --no-include-email --region $AWS_REGION)

TAG="${CIRCLE_BRANCH}-${CIRCLE_BUILD_NUM}"
SOURCE="${AWS_ECR_REPO_NAME}:${TAG}"
TARGET="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${SOURCE}"

docker build --rm=false -t $SOURCE .

IMAGE_ID=$(docker inspect $SOURCE --format={{.Id}} | cut -d':' -f2)
echo "Image ID is: $IMAGE_ID"

docker tag $SOURCE $TARGET
docker push $TARGET
