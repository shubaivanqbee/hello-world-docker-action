#!/bin/sh -l

token=$1
filename=$2
qbee_directory=$3
local_directory=$4

echo "init token $token filename $filename qbee_directory $qbee_directory and local_directory $local_directory"

apiOutput=$(curl -i --request "DELETE" -d "path=/$qbee_directory/$filename" -H "Content-type: application/x-www-form-urlencoded" \
   --url 'https://www.app.qbee.io:9443/api/v2/file'\
   --header 'Authorization: Bearer '"$1")
echo "API output is:\n$apiOutput"

apiOutput=$(curl -i --request POST -H "Content-Type:multipart/form-data" -F "path=/$qbee_directory/" -F "file=@$local_directory$filename" \
   --url 'https://www.app.qbee.io:9443/api/v2/file'\
   --header 'Authorization: Bearer '"$1")
echo "API output is:\n$apiOutput"

echo "::set-output name=token::$token"