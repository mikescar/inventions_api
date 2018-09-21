#!/bin/bash
set -e -o pipefail

# awscli is already installed in base docker image
$(aws ecr get-login --no-include-email --region $AWS_REGION)

TAG="${CIRCLE_BRANCH}-${CIRCLE_BUILD_NUM}"
DOMAIN="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
TARGET="${DOMAIN}/${AWS_ECR_REPO_NAME}:${TAG}"

# Avoid some circle warnings by not removing, it's ephemeral anyway
docker build --rm=false -t $TARGET .

IMAGE_ID=$(docker inspect $TARGET --format={{.Id}} | cut -d':' -f2)
echo "Image ID is: $IMAGE_ID"

docker push $TARGET
