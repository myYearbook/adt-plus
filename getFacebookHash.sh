#!/bin/bash
#
# Reads build properties for a keystore for an android product to generate the hash requested
# by facebook for Android native applications
#
# @author Dallas Gutauckis <dallas@myyearbook.com>
# @since 2011-06-09
#

buildProperties=$1

if [ ! $buildProperties ]; then
  buildProperties="build.properties";
fi;

echo $buildProperties;

keyAlias=`grep "key.alias=" $buildProperties | grep -Eo "=.*"`
keyAlias=${keyAlias:1}

keyStorePassword=`grep "key.store.password=" $buildProperties | grep -Eo "=.*"`
keyStorePassword=${keyStorePassword:1}

keyAliasPassword=`grep "key.store.password=" $buildProperties | grep -Eo "=.*"`
keyAliasPassword=${keyStorePassword:1}

keyStore=`grep "key.store=" $buildProperties | grep -Eo "=.*"`
keyStore=${keyStore:1}

keytool -exportcert -alias "${keyAlias}" -storepass "${keyStorePassword}" -keystore "${keyStore}" -keypass "${keyAliasPassword}" | openssl sha1 -binary | openssl enc -a -e
