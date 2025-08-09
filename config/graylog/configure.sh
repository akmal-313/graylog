#!/bin/bash

# Redirect all output (stdout and stderr) to config.log
exec > config.log 2>&1

echo "----- Starting script -----"

# Usage check
if [ $# -ne 1 ]; then
  echo "Usage: $0 input_json_file"
  exit 1
fi

INPUT_JSON="$1"
CONFIG_FILE="config.cfg"

echo "Input JSON file: $INPUT_JSON"
echo "Config file: $CONFIG_FILE"

# Check config file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "ERROR: Config file $CONFIG_FILE not found!"
  exit 2
fi
echo "Config file found."

# Source the config file to load variables
# shellcheck disable=SC1090
source "$CONFIG_FILE"

echo "Config loaded:"
echo "  api_url = $api_url"
echo "  username = ${username:-<not set>}"
echo "  password = ${password:+****}"
echo "  api_token = ${api_token:+****}"

# Validate api_url
if [[ -z "$api_url" ]]; then
  echo "ERROR: api_url not set in $CONFIG_FILE"
  exit 3
fi
echo "API URL validated."

# Decide auth method
if [[ -n "$api_token" ]]; then
  echo "Using API token authentication."
  AUTH_HEADER="Authorization: Bearer $api_token"
elif [[ -n "$username" && -n "$password" ]]; then
  echo "Using basic authentication with username and password."
  BASIC_AUTH=$(echo -n "$username:$password" | base64)
  AUTH_HEADER="Authorization: Basic $BASIC_AUTH"
else
  echo "ERROR: No valid credentials found in $CONFIG_FILE"
  exit 4
fi

echo "Sending POST request to ${api_url}/system/inputs with input file $INPUT_JSON..."

# Compose Authorization header for token auth
BASIC_AUTH=$(echo -n "${api_token}:token" | base64)
AUTH_HEADER="Basic $BASIC_AUTH"

# Curl call
curl -v -X POST "${api_url}/system/inputs" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: $AUTH_HEADER" \
  -H "X-Requested-By: cli" \
  -d @"$INPUT_JSON"

echo "----- Script finished -----"
