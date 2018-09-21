#!/bin/bash

set -e -o pipefail

apt-get install -y python-pip
pip install awscli

$(aws ecr get-login --no-include-email --region $AWS_REGION)

VERSIONED_TAG="${AWS_ECR_REPO_NAME}:${CIRCLE_BRANCH}-${CIRCLE_BUILD_NUM}"
docker build --rm=false -t $VERSIONED_TAG .

IMAGE_ID=$(docker inspect $VERSIONED_TAG --format={{.Id}} | cut -d':' -f2)
echo "Image ID is: $IMAGE_ID"

TARGET_TAG="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${VERSIONED_TAG}"
docker tag $VERSIONED_TAG $TARGET_TAG
docker push $TARGET_TAG
