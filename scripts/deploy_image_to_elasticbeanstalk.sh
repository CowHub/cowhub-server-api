#! /bin/bash
DOCKER_TAG=$1

DOCKERRUN_FILE=$DOCKER_TAG-Dockerrun.aws.json
EB_BUCKET=$DEPLOYMENT_BUCKET/$BUCKET_DIRECTORY

# Run aws command to create a new EB application with label
aws elasticbeanstalk create-application-version --region=$REGION --application-name $AWS_APPLICATION_NAME --version-label $DOCKER_TAG --source-bundle S3Bucket=$DEPLOYMENT_BUCKET,S3Key=$BUCKET_DIRECTORY/$DOCKERRUN_FILE
aws elasticbeanstalk update-application-version --application-name $AWS_APPLICATION_NAME --version-label $DOCKER_TAG
