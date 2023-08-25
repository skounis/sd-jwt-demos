# sd-jwt-demos

## Overview 
_{TBD}_

## Quick run
Open the repository in Codespace and run the following bash commands in the terminal

![Open in Codespace](assets/image-01-opencodespace.png)

Sign a sample payload and create its web signature:
```bash
make jws
```

Sign a sample payload and pack it with its signature into a JSON Web Token (JWT)
```bash
make jwt
```

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

## JSON Web Token (JWT)
A JSON Web Token (JWT) has three parts: the header, the payload, and the signature. Here's how they're structured:

1. Header: Typically consists of two parts: the type of token (JWT) and the signing algorithm being used, such as HMAC SHA256 or RSA.
   Example: {"alg": "HS256", "typ": "JWT"}

2. Payload: Contains the claims. Claims are statements about an entity (typically the user) and additional data.
   Example: {"sub": "1234567890", "name": "John Doe", "iat": 1516239022}

3. Signature: The signature is used to verify that the sender of the JWT is who it says it is and to ensure that the message wasn't changed along the way.
   To create the signature, you need to take the encoded header, the encoded payload, a secret, the algorithm specified in the header, and sign that.
   Example: HMACSHA256(
   base64UrlEncode(header) + "." +
   base64UrlEncode(payload),
   secret)

Note that these parts are base64url encoded and then concatenated using periods to form the JWT. The resulting JWT is of the form: `xxxxx.yyyyy.zzzzz`.

Please replace the examples with actual values when creating or working with JWTs.

### Create a JWT from JWS

Here is an example on how to create a JWT from the following JWS:
```json
{
   "protected":"{\"alg\": \"HS256\",\"typ\": \"JWT\"}",
   "payload":"{\"message\": \"This is a sample message\"}",
   "signature":"AqdXLKTbij++ZuHoYzVRnMV72BkWFPJWAnPdW2/2K8A"
}

```

First, let's break down the provided JWS into its components:

1. **Header**: `{"alg": "HS256", "typ": "JWT"}`
2. **Payload**: `{"message": "This is a sample message"}`
3. **Signature**: `AqdXLKTbij++ZuHoYzVRnMV72BkWFPJWAnPdW2/2K8A`

Now, let's create the JWT using these components:

1. Encode the Header and Payload components using base64url encoding:
   - Encoded Header: `eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9`
   - Encoded Payload: `eyJtZXNzYWdlIjogIlRoaXMgaXMgYSBzYW1wbGUgbWVzc2FnZSJ9`

2. Concatenate the encoded Header and Payload with a period (`.`) separator:
   - JOSE Header: `eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9.`
   - Encoded Payload: `eyJtZXNzYWdlIjogIlRoaXMgaXMgYSBzYW1wbGUgbWVzc2FnZSJ9`

3. Add the provided Signature:
   - Signature: `AqdXLKTbij++ZuHoYzVRnMV72BkWFPJWAnPdW2/2K8A`

4. Concatenate the JOSE Header and Encoded Payload with a period (`.`) separator, and then append the Signature:
   - JWT: `eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9.eyJtZXNzYWdlIjogIlRoaXMgaXMgYSBzYW1wbGUgbWVzc2FnZSJ9.AqdXLKTbij++ZuHoYzVRnMV72BkWFPJWAnPdW2/2K8A`

This is your completed JSON Web Token (JWT) based on the provided JSON Web Signature (JWS).

Please note that in practice, you would also need to include valid expiration (`exp`), issuer (`iss`), and subject (`sub`) claims in the payload to make the JWT more meaningful and secure.


#### JWT Security

> The JSON-based representation of claims in **a signed JWT is secured against modification** using JWS digital signatures. A consumer of a signed JWT that has checked the signature can safely assume that the contents of the token have not been modified. However, **anyone receiving an unencrypted JWT can read all the claims**. Likewise, anyone with the decryption key receiving encrypted JWT can also read all the claims.
>
> -- https://www.ietf.org/archive/id/draft-ietf-oauth-selective-disclosure-jwt-05.html#name-introduction-2


## SD-JWT notes
> The **Holder decides which claims to disclose** to a particular Verifier and includes the respective Disclosures in the SD-JWT to that Verifier. The Verifier has to verify that all disclosed claim values were part of the original Issuer-signed JWT. **The Verifier will not**, however, **learn any claim values not disclosed** in the Disclosures.
>
> -- https://www.ietf.org/archive/id/draft-ietf-oauth-selective-disclosure-jwt-05.html#section-1-8


> This document also specifies an optional mechanism for Key Binding, which is the concept of **binding an SD-JWT to a Holder's public key** and requiring that the Holder prove possession of the corresponding private key when presenting the SD-JWT.
>
> -- https://www.ietf.org/archive/id/draft-ietf-oauth-selective-disclosure-jwt-05.html#section-1-9



## References
* [Selective Disclosure for JWTs (SD-JWT)](https://www.ietf.org/archive/id/draft-ietf-oauth-selective-disclosure-jwt-05.html)
  * [Source and Issue tracking in GitHub](https://github.com/oauth-wg/oauth-selective-disclosure-jwt)