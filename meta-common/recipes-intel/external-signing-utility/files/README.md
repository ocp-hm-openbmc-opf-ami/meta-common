# **External Signing Utility**
This utility supports the following functionalities
- Fetch keys from the given location
- Install keys in specified destination
- Sign the hash with OpenSSL

## **Usage**
* **To fetch and install keys**
```
   external-signing-utility debug get_key <source-location-of-the-key> 
            <destination-location-of-the-key>
```

* **Sign the hash using OpenSSL**
```
   external-signing-utility debug sign <path-to-private-key> <hash-algo> 
            <input-hash> <signed-hash>
```
## **How to Use**
In respective meta-platform layers all the configuration files are installed to
install path for performing signing operation. Current utility enables user to
use an external script in the configuration files which can be used for signing 
the hash. The **external-signing-utility** expects a input hash file(data.hsh) 
which will be signed and written to data.sig. 

Users have the flexibility to customize/replace the script as per their needs for
fetching keys, installing keys and performing signing operations using a bbappend. 
The script when modified allows users to integrate fetching keys, installing keys 
and signing hash using **External Signing Server**


### **Example of a configuration file using external-signing-utility**


* **Signing procedure on Intel PFR Platforms**

~~~ xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- XML file for Block Sign Tool -->
<blocksign>
  <version>1</version>
  <!-- Block 0 -->
  <block0>
    <magic>0xB6EAFD19</magic>
    <pctype> </pctype>
  </block0>
  <!-- Block 1 -->
  <block1>
    <magic>0xF27F28D7</magic>
    <!-- Root key -->
    <rkey>
      <magic>0xA757A046</magic>
      <curvemagic> </curvemagic>
      <permissions>-1</permissions>
      <keyid>-1</keyid>
      <pubkey>Secp384r1PublicKey</pubkey>
    </rkey>
    <!-- Code signing key -->
    <cskey>
      <magic>0x14711C2F</magic>
      <curvemagic>0x08F07B47</curvemagic>
      <permissions>8</permissions>
      <keyid>1</keyid>
      <pubkey>Secp384r1PublicKey</pubkey>
      <sigmagic>0xEA2A50E9</sigmagic>
      <hashalg>sha384</hashalg>
      <script>external-signing-utility debug sign <path-to-root-private-key> sha384 data.hsh data.sig</script>
    </cskey>
    <!-- Signature over Block 0 -->
    <b0_sig>
      <magic>0x15364367</magic>
      <sigmagic>0xEA2A50E9</sigmagic>
      <hashalg>sha384</hashalg>
      <script>external-signing-utility debug sign <path-to-code-signing-private-key> sha384 data.hsh data.sig</script>
    </b0_sig>
  </block1>
  <padding>
    <!-- Pad block1 such that combined block length is 1024b -->
    <blockpad>1024</blockpad>
    <!-- Align total package to 128 bytes -->
    <align>128</align>
  </padding>
</blocksign>
~~~

* **Signing procedure on Secureboot Platforms using ASPEED signing utility** 

```
    socsec \
        make_secure_bl1_image \
        --algorithm ALGORITHM \
        --bl1_image BL1_IMAGE \
        --output OUTPUT \
        --rsa_sign_key RSA_SIGN_KEY \
        --rsa_key_order ORDER \
        --key_in_otp \
        --aes_key [AES_KEY] \
        --rsa_aes [RSA_AES_KEY] \
        --stack_intersects_verification_region "false" \
        --signing_helper_with_files <path-to-external-signing-utility> \
        --revision_id [REVISION_ID]
```
