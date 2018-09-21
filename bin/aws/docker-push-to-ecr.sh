#!/bin/bash

set -e -o pipefail

apt-get install py-pip
pip install awscli

$(aws ecr get-login --no-include-email --region $AWS_REGION)

docker build --rm=false -t $AWS_ECR_TAG .

IMAGE_ID=$(docker inspect $AWS_ECR_TAG --format={{.Id}} | cut -d':' -f2)
echo "Image ID is: $IMAGE_ID"

VERSIONED_TAG="${AWS_ECR_TAG}:${CIRCLE_BRANCH}-${CIRCLE_BUILD_NUM}"
TARGET_TAG="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${VERSIONED_TAG}"
docker tag $VERSIONED_TAG $TARGET_TAG
docker push $TARGET_TAG
