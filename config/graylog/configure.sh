#!/bin/bash

# Redirect all output (stdout and stderr) to config.log
exec > config.log 2>&1

echo "----- Starting script -----"

CONFIG_FILE="config.cfg"
WORKDIR="."   # directory containing JSON files
SUMMARY_FILE="summary.log"

echo "Looking for JSON files in directory: $WORKDIR"
echo "Config file: $CONFIG_FILE"

# Clean up old summary file
> "$SUMMARY_FILE"

# Check config file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "ERROR: Config file $CONFIG_FILE not found!"
  exit 1
fi
echo "Config file found."

# Source the config file to load variables
source "$CONFIG_FILE"

echo "Config loaded:"
echo "  api_url = $api_url"
echo "  username = ${username:-<not set>}"
echo "  password = ${password:+****}"
echo "  api_token = ${api_token:+****}"

# Validate api_url
if [[ -z "$api_url" ]]; then
  echo "ERROR: api_url not set in $CONFIG_FILE"
  exit 2
fi
echo "API URL validated."

# Decide auth method
if [[ -n "$api_token" ]]; then
  echo "Using API token authentication."
  BASIC_AUTH=$(echo -n "${api_token}:token" | base64)
  AUTH_HEADER="Basic $BASIC_AUTH"
elif [[ -n "$username" && -n "$password" ]]; then
  echo "Using basic authentication with username and password."
  BASIC_AUTH=$(echo -n "$username:$password" | base64)
  AUTH_HEADER="Basic $BASIC_AUTH"
else
  echo "ERROR: No valid credentials found in $CONFIG_FILE"
  exit 3
fi

echo "Starting to process JSON input files..."

shopt -s nullglob
JSON_FILES=("$WORKDIR"/*.json)

if [ ${#JSON_FILES[@]} -eq 0 ]; then
  echo "No JSON files found in directory $WORKDIR. Exiting."
  exit 0
fi

# Array to store results
declare -A results
success_count=0
failure_count=0

for JSON_FILE in "${JSON_FILES[@]}"; do
  echo "Processing JSON file: $JSON_FILE"

  HTTP_RESPONSE=$(curl -s -w "%{http_code}" -o /tmp/curl_response.json -X POST "${api_url}/system/inputs" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "Authorization: $AUTH_HEADER" \
    -H "X-Requested-By: cli" \
    -d @"$JSON_FILE")

  echo "  HTTP response code: $HTTP_RESPONSE"

  if [[ "$HTTP_RESPONSE" -ge 200 && "$HTTP_RESPONSE" -lt 300 ]]; then
    echo "  SUCCESS: Input created successfully."
    results["$JSON_FILE"]="SUCCESS ($HTTP_RESPONSE)"
    ((success_count++))
  else
    echo "  FAILURE: Error creating input."
    results["$JSON_FILE"]="FAILURE ($HTTP_RESPONSE)"
    ((failure_count++))
    sed 's/^/    /' /tmp/curl_response.json
  fi
done

# Print and log summary
{
  echo "----- Execution Summary -----"
  for file in "${!results[@]}"; do
    echo "$file => ${results[$file]}"
  done
  echo "-----------------------------"
  echo "Total files: ${#JSON_FILES[@]}"
  echo "Successful: $success_count"
  echo "Failed: $failure_count"
  echo "-----------------------------"
} | tee "$SUMMARY_FILE"

echo "----- Script finished -----"
