#! /bin/bash
DOCKER_TAG=$1

# Prefix of file name is the tag.
SOURCE_BUNDLE=$DOCKER_TAG
S3_PATH="s3://$DEPLOYMENT_BUCKET/$BUCKET_DIRECTORY/$SOURCE_BUNDLE.zip"

# Print env variables for debugging
echo "DOCKER_TAG:\t$DOCKER_TAG"
echo "DEPLOYMENT_BUCKET:\t$DEPLOYMENT_BUCKET"
echo "IMAGE_NAME:\t$IMAGE_NAME"
echo "EXPOSED_PORTS:\t$EXPOSED_PORTS"
echo "AUTHENTICATION_KEY:\t$AUTHENTICATION_KEY"

# Replacing tags in the file and creating a file.
sed -e "s/<TAG>/$DOCKER_TAG/" -e "s/<DEPLOYMENT_BUCKET>/$DEPLOYMENT_BUCKET/" -e "s/<IMAGE_NAME>/$IMAGE_NAME/" -e "s/<EXPOSED_PORTS>/$EXPOSED_PORTS/" -e "s/<AUTHENTICATION_KEY>/$AUTHENTICATION_KEY/" < ./scripts/Dockerrun.aws.json.template > ./scripts/Dockerrun.aws.json

# Bundle
cd scripts
cp -r ../.ebextensions ./
zip -r $SOURCE_BUNDLE.zip .ebextensions Dockerrun.aws.json

# Uploading json file to $S3_PATH
aws s3 cp $SOURCE_BUNDLE.zip $S3_PATH
