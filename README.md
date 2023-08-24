# sd-jwt-demos

## Overview 
_{TBD}_


## JSON Web Signature

A simple example of a JSON Web Signature (JWS) structure:

```json
{
  "protected": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9",
  "payload": "VGhpcyBpcyBhIHNhbXBsZSBtZXNzYWdl",
  "signature": "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk"
}
```

In this example:
- The `"protected"` field contains the base64url-encoded header parameters (such as algorithm and type).
- The `"payload"` field contains the base64url-encoded data that you want to sign.
- The `"signature"` field contains the signature generated using the algorithm specified in the header, applied to the concatenated base64url-encoded `"protected"` and `"payload"` values.

Remember that in actual use cases, the header parameters and payload will contain meaningful data, and the signature will be generated using a real cryptographic algorithm. The values in this example are just base64url-encoded strings for illustration purposes.

Here's the same example of a JSON Web Signature (JWS) structure with the fields unencoded:

```json
{
  "protected": "{ \"alg\": \"HS256\", \"typ\": \"JWT\" }",
  "payload": "This is a sample message",
  "signature": "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk"
}
```

In this example:
- The `"protected"` field contains the header parameters in JSON format, specifying the algorithm (`"HS256"`) and the type (`"JWT"`).
- The `"payload"` field contains the data that you want to sign (`"This is a sample message"`).
- The `"signature"` field contains the signature generated using the HMAC-SHA256 algorithm applied to the concatenated `protected` and `payload` values. The actual signature value is just a placeholder in this example.

### Create a signature
Here's an example of how you could create the signature for the given JSON Web Signature (JWS) structure using the HMAC-SHA256 algorithm:

1. Calculate the Base64Url-encoded **header**, `{"alg":"HS256","typ":"JWT"}`, and **payload**, `This is a sample message`:  
   
   ```
   Base64Url(header) = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"
   Base64Url(payload) = "VGhpcyBpcyBhIHNhbXBsZSBtZXNzYWdl"
   ```

3. Concatenate the Base64Url-encoded header and payload with a period `.` separator:
   ```
   dataToSign = Base64Url(header) + "." + Base64Url(payload)
   dataToSign = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.VGhpcyBpcyBhIHNhbXBsZSBtZXNzYWdl"
   ```

4. Use the HMAC-SHA256 algorithm with a secret key to generate the signature:
   ```
   secretKey = "your_secret_key_here"
   signature = HMAC-SHA256(dataToSign, secretKey)
   ```

5. Convert the signature to Base64Url format:
   ```
   Base64Url(signature) = "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk"
   ```

6. Construct the final JWS by putting the Base64Url-encoded header, payload, and signature together:
   ```json
   {
     "protected": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9",
     "payload": "VGhpcyBpcyBhIHNhbXBsZSBtZXNzYWdl",
     "signature": "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk"
   }
   ```

Please note that in a real-world scenario, you would use proper cryptographic libraries and functions to handle the encoding, hashing, and signing steps. The example above is a simplified illustration of the process.

### Bash command
Here's an example of a bash command that demonstrates how to create the signature using the HMAC-SHA256 algorithm:

```bash
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
```

Make sure to replace `"your_secret_key_here"` with your actual secret key. This script calculates the HMAC-SHA256 signature using OpenSSL and outputs the final JWS structure.

Remember that this is a simplified example for demonstration purposes, and in a production environment, you should use proper libraries and tools for handling cryptographic operations.
