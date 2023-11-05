#!/bin/sh

RED='\033[0;31m';
GREEN='\033[1;32m';
YELLOW='\033[1;33m';
LITE_CYAN='\e[96m';
NC='\033[0m';

if [ -z ${gitea_schema} ]; then
    printf "${RED}FAILED${NC} \n"
    printf "Error message:  ${RED}Option {gitea_schema} is not set${NC} \n"
    exit 1;
fi

if [ ${gitea_schema} = '' ]; then
    printf "${RED}FAILED${NC} \n"
    printf "Error message:  ${RED}Option {gitea_schema} must be a non-empty string${NC} \n"
    exit 1;
fi


if [ -z ${gitea_host} ]; then
    printf "${RED}FAILED${NC} \n"
    printf "Error message:  ${RED}Option {gitea_host} is not set${NC} \n"
    exit 1;
fi

if [ ${gitea_host} = '' ]; then
    printf "${RED}FAILED${NC} \n"
    printf "Error message:  ${RED}Option {gitea_host} must be a non-empty string${NC} \n"
    exit 1;
fi


if [ -z ${gitea_organization} ]; then
    printf "${RED}FAILED${NC} \n"
    printf "Error message:  ${RED}Option {gitea_organization} is not set${NC} \n"
    exit 1;
fi

if [ ${gitea_organization} = '' ]; then
    printf "${RED}FAILED${NC} \n"
    printf "Error message:  ${RED}Option {gitea_organization} must be a non-empty string${NC} \n"
    exit 1;
fi


if [ -z ${gitea_repo} ]; then
    printf "${RED}FAILED${NC} \n"
    printf "Error message:  ${RED}Option {gitea_repo} is not set${NC} \n"
    exit 1;
fi

if [ ${gitea_repo} = '' ]; then
    printf "${RED}FAILED${NC} \n"
    printf "Error message:  ${RED}Option {gitea_repo} must be a non-empty string${NC} \n"
    exit 1;
fi


if [ -z ${access_token} ]; then
    printf "${RED}FAILED${NC} \n"
    printf "Error message:  ${RED}Option {access_token} is not set${NC} \n"
    exit 1;
fi

if [ ${access_token} = '' ]; then
    printf "${RED}FAILED${NC} \n"
    printf "Error message:  ${RED}Option {access_token} must be a non-empty string${NC} \n"
    exit 1;
fi

printf "api request url=${YELLOW} ${gitea_schema}://${gitea_host}/api/v1/repos/${gitea_organization}/${gitea_repo}/releases ${NC} \n";
printf "body=${YELLOW}${release_body}${NC} \n";
printf "draft=${YELLOW}${release_draft}${NC} \n";
printf "name=${YELLOW}${release_name}${NC} \n";
printf "prerelease=${YELLOW}${release_prerelease}${NC} \n";
printf "tag_name=${YELLOW}${release_tag_name}${NC} \n";
printf "target_commitish=${YELLOW}${release_target_commitish}${NC} \n";

response=$( curl -X 'POST' \
  "${gitea_schema}://${gitea_host}/api/v1/repos/${gitea_organization}/${gitea_repo}/releases?access_token=${access_token}" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d "{
  \"body\": \"${release_body}\",
  \"draft\": ${release_draft},
  \"name\": \"${release_name}\",
  \"prerelease\": ${release_prerelease},
  \"tag_name\": \"${release_tag_name}\",
  \"target_commitish\": \"${release_target_commitish}\"
}")

id=$(echo $response | jq '.id');
url=$(echo $response | jq '.html_url');
message=$(echo $response | jq '.message');

if [ $id = 'null' ]; then
    printf "${RED}FAILED${NC} \n"
    printf "Create release error: Error message:  ${RED}$message${NC} \n"
    exit 1;
else
    printf "${GREEN}SUCCESS${NC} \n"
    printf "Created release: id: ${YELLOW}$id${NC} \nurl: ${YELLOW}$url${NC} \n"
fi

