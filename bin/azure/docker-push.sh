#!/bin/bash
set -e -o pipefail

SOURCE_IMAGE=$1
CR_DOMAIN="${AZURE_ACR_NAME}.azurecr.io"
TARGET_IMAGE="${CR_DOMAIN}/${APP_NAME_PRODUCTION}:${SOURCE_IMAGE}"

docker tag $SOURCE_IMAGE $TARGET_IMAGE

echo Image ID is: $(docker inspect $TARGET_IMAGE --format={{.Id}} | cut -d':' -f2)

docker login --username=$AZURE_SP_ID --password=$AZURE_SP_PASSWD $CR_DOMAIN
docker push $TARGET_IMAGE

# Actually deploy in ACI
# az container create \
#     --resource-group demos \
#     --name $APP_NAME_PRODUCTION \
#     --image $IMAGE_ID \
#     --registry-login-server mikescar.azurecr.io \
#     --registry-username $AZURE_SP_ID \
#     --registry-password $AZURE_SP_PASSWD
