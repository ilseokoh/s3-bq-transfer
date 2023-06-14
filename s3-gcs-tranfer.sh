#!/usr/bin/env bash

AWS_BUCKET_NAME=
GCS_BUCKET_NAME=
# comma seperated prefix list ex) abc,def
INCLUDE_PREFIXES=
JOB_NAME=$(echo "s3_transfer_$RANDOM$RANDOM")

echo Create data transfer job from S3 to GCS

# CREATE JOB
gcloud transfer jobs create s3://$AWS_BUCKET_NAME gs://$GCS_BUCKET_NAME \
    --include-prefixes=$INCLUDE_PREFIXES --source-creds-file=creds.txt \
    --description="S3 data trasfer include '$INCLUDE_PREFIXES'" \
    --name=$JOB_NAME

## Monitoring job
gcloud transfer jobs monitor $JOB_NAME