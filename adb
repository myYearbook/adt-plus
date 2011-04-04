#!/bin/bash

#####################################################
# An ADB-wrapper to add a few extra features...     #
#                                                   #
# Author: Dallas Gutauckis <dallas@gutauckis.com>   #
# Since: 2011-04-02 18:19:16 EDT                    #
#####################################################

##   CONFIGURATION
#
# The path to your adb binary
ADB="/Users/dallas/android/platform-tools/adb"

##  USAGE
#
# See README.md

#!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*#
# Users: do not edit beyond this point #
#!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*#

input=$@

is_install=0;
for i in $input; do
  if [ $i = 'install' ]; then
    is_install=1
  fi;

  if [ $is_install ] && ( [ ${i:0:7} = 'http://' ] || [ ${i:0:8} = 'https://' ] ); then
    url=$i

    if [ ! $url ]; then
      echo "No URL specified.";
      exit 1;
    fi;

    if [ ! -d "/tmp/adb-curl/" ]; then
      mkdir /tmp/adb-curl/;
    fi;

    tmpFile="/tmp/adb-curl/$$.apk";
    touch $tmpFile;

    response=`curl ${url} -s -w '%{http_code}' -o $tmpFile`

    while [ $response = '403' ] || [ $response = '401' ]; do
      echo "Authentication Required.";
      read -p "Username: " username;
      read -sp "Password: " password;
      echo -e "\n";
      response=`curl ${url} -u "$username:$password" -s -w '%{http_code}' -o $tmpFile`;
    done;

    if [ ! $response = '200' ]; then
      echo "Failed to retrieve apk file.";
      exit 1;
    fi;

    input=${input/"${i}"/"${tmpFile}"}
  fi;
done;

for i in $input; do
  ## If we're specifying a serial to target, check to see if we can help out
  if [ $i = '-a' ]; then
    is_multiple=1
    input=${input/-a/}
   
    ## Expand to ALL devices
    devices=`"${ADB}" devices | grep -E 'device$' | cut -f1`;

    for device in $devices; do
      echo "### $device:";
      "${ADB}" -s $device $input
    done;
  fi;
done;

if [ ! $is_multiple ]; then
  "${ADB}" $input
fi;

if [ $tmpFile ]; then
  rm $tmpFile;
fi;
