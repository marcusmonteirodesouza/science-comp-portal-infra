#!/bin/bash

# https://cloud.google.com/build/docs/configuring-builds/use-community-and-custom-builders

PROJECT=$1
REGION=$2
HPC_TOOLKIT_REPOSITORY=$3

git clone https://github.com/marcusmonteirodesouza/hpc-toolkit.git

pushd hpc-toolkit || exit 1

cp 'tools/cloud-build/Dockerfile' .

gcloud builds submit --project "$PROJECT" --tag "$REGION-docker.pkg.dev/$PROJECT/$HPC_TOOLKIT_REPOSITORY/hpc-toolkit" --timeout '30m'

popd || exit 1

rm -rf hpc-toolkit

git clone https://github.com/GoogleCloudPlatform/cloud-builders-community.git

pushd cloud-builders-community/terraform || exit 1

gcloud builds submit --project "$PROJECT" .

popd || exit 1

rm -rf cloud-builders-community
