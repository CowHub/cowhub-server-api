#! /bin/bash
DOCKER_TAG=$1

VERSION_LABEL=$DOCKER_TAG
DOCKERRUN_FILE=$VERSION_LABEL-Dockerrun.aws.json
EB_BUCKET=$DEPLOYMENT_BUCKET/$BUCKET_DIRECTORY

# Print env variables for debugging
echo "REGION:\t$REGION"
echo "AWS_APPLICATION_NAME:\t$AWS_APPLICATION_NAME"
echo "DOCKER_TAG:\t$DOCKER_TAG"
echo "DEPLOYMENT_BUCKET:\t$DEPLOYMENT_BUCKET"
echo "BUCKET_DIRECTORY:\t$BUCKET_DIRECTORY"
echo "DOCKERRUN_FILE:\t$DOCKERRUN_FILE"

echo "CREATING APPLICATION VERSION..."
# Run aws command to create a new EB application with label
aws elasticbeanstalk create-application-version --region=$REGION --application-name $AWS_APPLICATION_NAME --version-label $VERSION_LABEL --source-bundle S3Bucket=$DEPLOYMENT_BUCKET,S3Key=$BUCKET_DIRECTORY/$DOCKERRUN_FILE

echo "UPDATING APPLICATION VERSION..."
cd scripts
eb init $AWS_APPLICATION_NAME -r $REGION
eb deploy -l $VERSION_LABEL
