#!/bin/bash
set -e -o pipefail

SOURCE_IMAGE=$1
DOMAIN="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
TARGET_IMAGE="${DOMAIN}/${AWS_ECR_REPO_NAME}:${SOURCE_IMAGE}"

docker tag $SOURCE_IMAGE $TARGET_IMAGE

echo Image ID is: $(docker inspect $TARGET_IMAGE --format={{.Id}} | cut -d':' -f2)

# awscli is already installed in base docker image
$(aws ecr get-login --no-include-email --region $AWS_REGION)
docker push $TARGET_IMAGE
