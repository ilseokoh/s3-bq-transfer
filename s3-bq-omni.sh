#!/usr/bin/env bash

BQ_DATASET=
FORMAT=
AWS_BUCKET_NAME=
CONNECTION_ID=
PREFIX_DEPTH_1=

echo BigQuery Omni table creation job
echo tables to create

table_arr=($(aws s3 ls s3://$AWS_BUCKET_NAME/$PREFIX_DEPTH_1 | awk '{if ($1 == "PRE") print $2}'))
declare -p table_arr

echo $table_arr

for i in "${table_arr[@]}"
do
    table_name=$(echo "$i" | sed 's:/*$::')
    echo "Create $table_name .... "

    # create table definition file
    bq mkdef \
        --source-format=$FORMAT \
        --connection_id=$CONNECTION_ID \
        s3://$AWS_BUCKET_NAME/$PREFIX_DEPTH_1/$table_name > $table_name.def

    # create table
    bq mk --external_table_definition=table_def $BQ_DATASET.$table_name
done