#!/usr/bin/env bash

AWS_BUCKET_NAME=
PROJECT_ID=
DATASET=
AWS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
PREFIX_DEPTH_1=

echo Create BigQuery data transfer job 
echo table to create

table_arr=($(aws s3 ls s3://$AWS_BUCKET_NAME/$PREFIX_DEPTH_1/ | awk '{if ($1 == "PRE") print $2}'))
declare -p table_arr

echo $table_arr

for i in "${table_arr[@]}"
do
    table_name=$(echo "$i" | sed 's:/*$::')  # remove slash
    echo "Create $table_name .... "

    # create Bigquery Table
    bq mk \
    --table \
    --description "s3 2 bq table" \
    $PROJECT_ID:$DATASET.$table_name

    # create bigquery transfer service 
    # it starts automatically    
    bq mk --transfer_config \
        --project_id=$PROJECT_ID \
        --data_source=amazon_s3 \
        --display_name=$table_name \
        --target_dataset=s3_data \
        --params='{
            "data_path":"s3://'"$AWS_BUCKET_NAME"'/'"$PREFIX_DEPTH_1"'/'"$table_name"'/*",
            "destination_table_name_template":"'"$table_name"'",
            "file_format":"PARQUET",
            "write_disposition":"WRITE_APPEND",
            "access_key_id":"'"$AWS_KEY_ID"'",
            "secret_access_key":"'"$AWS_SECRET_ACCESS_KEY"'"
        }'
done
