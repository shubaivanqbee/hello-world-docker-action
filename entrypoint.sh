#!/bin/sh -l

token=$1
filename=$2
qbee_directory=$3
local_directory=$4
successful_status_code='200'

echo "init token $token filename $filename qbee_directory $qbee_directory and local_directory $local_directory"

apiOutput=$(curl -i --request "DELETE" -d "path=/$qbee_directory/$filename" -H "Content-type: application/x-www-form-urlencoded" \
   --url 'https://www.app.qbee.io:9443/api/v2/file'\
   --header 'Authorization: Bearer '"$1"\
   -w "\n{\"http_code\":%{http_code}}\n")

echo 'DELETE request'
http_code=$(echo $output | jq -cs | jq -r '.[1].http_code')
echo $http_code
tokenValue=$(echo $output | jq -cs | jq -r '.[0].token')
echo $tokenValue)

if [ "$http_code" != "$successful_status_code" ]

then
    echo "http_code was - $http_code"
    exit 1
:
else
    echo "http_code was - $http_code"
fi

echo "API output is:\n$apiOutput"

apiOutput=$(curl -i --request POST -H "Content-Type:multipart/form-data" -F "path=/$qbee_directory/" -F "file=@$local_directory$filename" \
   --url 'https://www.app.qbee.io:9443/api/v2/file'\
   --header 'Authorization: Bearer '"$1"\
   -w "\n{\"http_code\":%{http_code}}\n")

echo 'POST request'
http_code=$(echo $output | jq -cs | jq -r '.[1].http_code')
echo $http_code
tokenValue=$(echo $output | jq -cs | jq -r '.[0].token')
echo $tokenValue)

if [ "$http_code" != "$successful_status_code" ]

then
    echo "http_code was - $http_code"
    exit 1
:
else
    echo "http_code was - $http_code"
fi

echo "API output is:\n$apiOutput"

echo "::set-output name=token::$token"