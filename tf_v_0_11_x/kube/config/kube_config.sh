API_KEY=$1            # IBM Cloud API Key
IKS_NAME=$2           # Name of IKS on VPC Cluster
RESOURCE_GROUP_ID=$3  # Resource group ID

# Fetch Access and refresh token

AUTHORIZATION="Basic Yng6Yng="
TOKEN=$(echo $(curl -i -k -X POST \
      --header "Content-Type: application/x-www-form-urlencoded" \
      --header "Authorization: $AUTHORIZATION" \
      --data-urlencode "apikey=$API_KEY" \
      --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey" \
      "https://iam.cloud.ibm.com/identity/token"))

# IAM Access Token
ACCESS_TOKEN=$(echo $TOKEN | sed -e s/.*access_token\":\"//g | sed -e s/\".*//g)
# IAM Refresh token
REFRESH_TOKEN=$(echo $TOKEN | sed -e s/.*refresh_token\":\"//g | sed -e s/\".*//g)      

# Get IBM Kuber Config file and save to temporary file
curl -X GET \
    "https://containers.cloud.ibm.com/global/v1/clusters/$IKS_NAME/config/admin" \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -H "X-Auth-Refresh-Token: $REFRESH_TOKEN" \
    -H 'Content-Type: application/json' \
    -H "X-Auth-Resource-Group: $RESOURCE_GROUP_ID" > tmp.zip

# List of files in zip
FILES=$(unzip -l tmp.zip)
# Name of subfolder containing data
ROOT_NAME="k$(echo $FILES | sed -e 's/.* k//g; s/\/.*//g')"
# Names of all the files as a list
NAMES=$(unzip -l tmp.zip | sed -e 's/.*'$ROOT_NAME'\///g' | sed -n '5,8p')

COUNT=0 # Number of files completed


# For each file pipes data from zip into variable
for file in $NAMES;
do

    if [ $COUNT == 0 ]; then
        ADMIN_KEY=$(unzip -p tmp.zip "$ROOT_NAME/$file")
    elif [ $COUNT == 1 ]; then
        ADMIN=$(unzip -p tmp.zip "$ROOT_NAME/$file")
    elif [ $COUNT == 2 ]; then        
        CA_CERT=$(unzip -p tmp.zip "$ROOT_NAME/$file")
    else
        CONFIG=$(unzip -p tmp.zip "$ROOT_NAME/$file")
    fi

    COUNT=$((COUNT + 1))

done

# Gets IKS host
HOST=$(echo "$CONFIG" | sed -n 6p | sed -e 's/ *server: //')

# Remove temporty zip file
rm -rf tmp.zip 

jq -n --arg admin_key "$ADMIN_KEY" \
      --arg admin "$ADMIN" \
      --arg ca_cert "$CA_CERT" \
      --arg config "$CONFIG" \
      --arg host "$HOST" \
        '{
          "admin_key":$admin_key, 
          "admin":$admin, 
          "ca_cert":$ca_cert, 
          "config":$config, 
          "host":$host
        }'