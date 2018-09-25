#!/bin/bash
set -e -o pipefail

SOURCE_IMAGE=$1
CR_DOMAIN="${AZURE_ACR_NAME}.azurecr.io"
TARGET_IMAGE="${CR_DOMAIN}/${APP_NAME_PRODUCTION}:${SOURCE_IMAGE}"

docker tag $SOURCE_IMAGE $TARGET_IMAGE

IMAGE_ID=$(docker inspect $TARGET_IMAGE --format={{.Id}} | cut -d':' -f2)
echo Image ID is: $IMAGE_ID

# Examples for creating and updating roles for Azure service principals:
# https://github.com/Azure-Samples/azure-cli-samples/tree/master/container-registry
docker login --username=$AZURE_SP_ID --password=$AZURE_SP_PASSWD $CR_DOMAIN
docker push $TARGET_IMAGE

# Deploy to Azure Container Instance
APP_NAME=${APP_NAME_PRODUCTION}-${CIRCLE_BRANCH}

az container create \
  --resource-group demos \
  --name $APP_NAME \
  --image $TARGET_IMAGE \
  --cpu 1 \
  --memory 1 \
  --registry-username $AZURE_SP_ID \
  --registry-password $AZURE_SP_PASSWD \
  --dns-name-label $APP_NAME \
  --ports 80
