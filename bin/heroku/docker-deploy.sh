#!/bin/bash

set -e -o pipefail

TAG="registry.heroku.com/${APP_NAME_PRODUCTION}/web"

docker build --rm=false -t $TAG .

IMAGE_ID=$(docker inspect $TAG --format={{.Id}} | cut -d':' -f2)
echo "Image ID is: $IMAGE_ID"

docker login --username=_ --password=$HEROKU_API_KEY registry.heroku.com
docker push $TAG

# TODO exit 1 if curl command returns error message
curl -n -X PATCH https://api.heroku.com/apps/${APP_NAME_PRODUCTION}/formation \
  -d '{
  "updates": [
    {
      "type": "web",
      "docker_image": "$IMAGE_ID"
    }
  ]
}' \
  -H "Content-Type: application/json" \
  -H "Accept: application/vnd.heroku+json; version=3.docker-releases" \
  -H "Authorization: Bearer $HEROKU_API_KEY"
