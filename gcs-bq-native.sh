#!/usr/bin/env bash

PROJECT_ID=
GCS_BUCKET_NAME=
DATASET=
PREFIX_DEPTH_1=

table_arr=($(gsutil ls -d "gs://$GCS_BUCKET_NAME/$PREFIX_DEPTH_1/*" | sed "s/gs:\/\/$GCS_BUCKET_NAME\/$PREFIX_DEPTH_1\///"g | sed '/^$/'d))
declare -p table_arr

for i in "${table_arr[@]}"
do
    table_name=$(echo "$i" | sed 's:/*$::')
    echo "Create $table_name .... "

    bq mk \
    --expiration 3600 \
    --table \
    --description "GCS 2 bq table" \
    $PROJECT_ID:$DATASET.$table_name

    bq load --source_format=PARQUET \
        $PROJECT_ID:$DATASET.$table_name \
        "gs://$GCS_BUCKET_NAME/$PREFIX_DEPTH_1/$table_name/*"
done
