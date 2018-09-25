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

# Deploy image to ACI
# az container create \
#     --resource-group demos \
#     --name $APP_NAME_PRODUCTION \
#     --image $IMAGE_ID \
#     --registry-login-server mikescar.azurecr.io \
#     --registry-username $AZURE_SP_ID \
#     --registry-password $AZURE_SP_PASSWD
