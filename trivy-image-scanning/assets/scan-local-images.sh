#!/bin/bash
# script inspired by: https://medium.com/linkbynet/cve-2021-44228-finding-log4j-vulnerable-k8s-pods-with-bash-trivy-caa10905744d
# This script loops over all the local images
# The first arg is the vulnerability name e.g. CVE-2021-44228
# All images are scanned by trivy and any that contain the vulnerability in the arg will be flagged

# Check command existence before using it
if ! command -v trivy &> /dev/null; then
  echo "trivy not found, please install it"
  exit
fi

RED="\e[31;1m"
GREEN="\e[32;1m"
NC="\e[0m\n"

OLDIFS="$IFS"
IFS=$'\n'
VULN=$1

summary=()
failed=()

echo "Scanning for $VULN..."

# loop through all the local images with valid tags
imgs=`docker image ls --format "{{.Repository}}:{{.Tag}}" | grep -v '<none>' | sort -u`
for img in ${imgs}; do
  source="$img"

  echo "Source: $source"

  # scan the image using trivy
  result=`trivy image ${source}`
  if [ $? -ne 0 ]; then
    printf "${RED}%s failed scanning${NC}" "$source"
    failed+=("$source failed scanning")
  elif echo ${result} | grep -q "$VULN" ; then
    printf "${RED}%s is vulnerable with %s${NC}" "$source" "$VULN"
    summary+=("$source is vulnerable with ${VULN}")
  else
    printf "${GREEN}%s does not contain vulnerability %s${NC}" "$source" "$VULN"
  fi
done < <(jq -c '.images | to_entries | .[]' $images_json)

echo ""
if [ ! -z "${failed[*]}" ]; then
  printf "${RED}One or more images is failed scanning, see list below:${NC}"
  printf '%s\n' "${failed[@]}"
  echo ""
fi

echo -n "Summary: "
if [ ! -z "${summary[*]}" ]; then
  printf "${RED}One or more images is vulnerable with %s, see list below:${NC}" "$VULN"
  printf '%s\n' "${summary[@]}"
else
  printf "${GREEN}No images contain vulnerability %s according to trivy scanning${NC}" "$VULN"
fi

IFS="$OLDIFS"