#!/bin/bash

set -e -o pipefail

apk add py-pip
pip install awscli

$(aws ecr get-login --no-include-email --region $AWS_REGION)

docker build --rm=false -t $AWS_ECR_TAG .

IMAGE_ID=$(docker inspect $AWS_ECR_TAG --format={{.Id}} | cut -d':' -f2)
echo "Image ID is: $IMAGE_ID"

SOURCE_TAG="${AWS_ECR_TAG}:latest"
TARGET_TAG="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${AWS_ECR_TAG}:latest"
docker tag $SOURCE_TAG $TARGET_TAG
docker push $TARGET_TAG
