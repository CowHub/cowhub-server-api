#! /bin/bash
DOCKER_TAG=$1

# Prefix of file name is the tag.
DOCKERRUN_FILE=$DOCKER_TAG-Dockerrun.aws.json

# Replacing tags in the file and creating a file.
sed -e "s/<TAG>/$DOCKER_TAG/" -e "s/<DEPLOYMENT_BUCKET>/$DEPLOYMENT_BUCKET/" -e "s/<IMAGE_NAME>/$IMAGE_NAME/" -e "s/<EXPOSED_PORTS>/$EXPOSED_PORTS/" -e "s/<AUTHENTICATION_KEY>/$AUTHENTICATION_KEY/" < ./scripts/Dockerrun.aws.json.template > ./scripts/$DOCKERRUN_FILE
S3_PATH="s3://$DEPLOYMENT_BUCKET/$BUCKET_DIRECTORY/$DOCKERRUN_FILE"

# Uploading json file to $S3_PATH
aws s3 cp ./scripts/$DOCKERRUN_FILE $S3_PATH
