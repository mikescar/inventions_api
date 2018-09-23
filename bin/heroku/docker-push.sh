#!/bin/bash
set -e -o pipefail

SOURCE_IMAGE=$1
TARGET_IMAGE="registry.heroku.com/${APP_NAME_PRODUCTION}/web"

echo Source image tag: $SOURCE_IMAGE
docker tag $SOURCE_IMAGE $TARGET_IMAGE

IMAGE_ID=$(docker inspect $TARGET_IMAGE --format={{.Id}} | cut -d':' -f2)
echo Image ID is: $IMAGE_ID

docker login --username=_ --password=$HEROKU_API_KEY registry.heroku.com
docker push $TARGET_IMAGE

sleep 5s

generate_patch_data()
{
  cat <<EOF
  {
    "updates": [
      {
        "type": "web",
        "docker_image": "$IMAGE_ID"
      }
    ]
  }
EOF
}

echo Requesting image deploy for: $(generate_patch_data)

# TODO exit 1 if curl exits 0 but outputs error message
curl -n -X PATCH https://api.heroku.com/apps/${APP_NAME_PRODUCTION}/formation \
  --data "$(generate_patch_data)" \
  -H "Content-Type: application/json" \
  -H "Accept: application/vnd.heroku+json; version=3.docker-releases" \
  -H "Authorization: Bearer $HEROKU_API_KEY"
