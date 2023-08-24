#!/bin/bash

# Define the header and payload as strings
header='{"alg": "HS256","typ": "JWT"}'
payload='{"message": "This is a sample message"}'

# Combine the Base64Url-encoded header and payload
dataToSign=$(echo -n "$header" | base64 -w 0 | sed 's/=//g').$(echo -n "$payload" | base64 -w 0 | sed 's/=//g')

# Define your secret key
secretKey="your_secret_key_here"

# Calculate the HMAC-SHA256 signature
signature=$(echo -n "$dataToSign" | openssl dgst -binary -sha256 -hmac "$secretKey" | base64 -w 0 | sed 's/=//g')

# Construct the final JWS
jws='{"protected":"'$header'","payload":"'$payload'","signature":"'$signature'"}'

echo $jws
