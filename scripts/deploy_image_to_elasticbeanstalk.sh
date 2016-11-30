#! /bin/bash
DOCKER_TAG=$1

DOCKERRUN_FILE=$DOCKER_TAG-Dockerrun.aws.json
EB_BUCKET=$DEPLOYMENT_BUCKET/$BUCKET_DIRECTORY

# Print env variables for debugging
echo -e "REGION:\t$REGION"
echo -e "AWS_APPLICATION_NAME:\t$AWS_APPLICATION_NAME"
echo -e "DOCKER_TAG:\t$DOCKER_TAG"
echo -e "DEPLOYMENT_BUCKET:\t$DEPLOYMENT_BUCKET"
echo -e "BUCKET_DIRECTORY:\t$BUCKET_DIRECTORY"
echo -e "DOCKERRUN_FILE:\t$DOCKERRUN_FILE"

# Run aws command to create a new EB application with label
aws elasticbeanstalk create-application-version --region=$REGION --application-name $AWS_APPLICATION_NAME --version-label $DOCKER_TAG --source-bundle S3Bucket=$DEPLOYMENT_BUCKET,S3Key=$BUCKET_DIRECTORY/$DOCKERRUN_FILE

# Deploy application
aws elasticbeanstalk update-application-version --application-name $AWS_APPLICATION_NAME --version-label $DOCKER_TAG
