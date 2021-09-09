#!/bin/bash -l


echo $SHELL

bash --version

token=$1
filename=$2
qbee_directory=$3
local_directory=$4
successful_status_code='200'

echo "init token $token filename $filename qbee_directory $qbee_directory and local_directory $local_directory"

apiOutput=$(curl --request "DELETE" -sL -d "path=/$qbee_directory/$filename" -H "Content-type: application/x-www-form-urlencoded" \
   --url 'https://www.app.qbee.io:9443/api/v2/file'\
   --header 'Authorization: Bearer '"$token"\
   -w "\n{\"http_code\":%{http_code}}\n")
echo $apiOutput
echo 'DELETE request'
http_code=$(echo $apiOutput | jq -cs | jq -r '.[1].http_code')
echo $http_code

if [ "$http_code" == "null" ]; then
    http_code=$(echo $apiOutput | jq -cs | jq -r '.[0].http_code')
else
    echo "http_code was no null"
fi

if [[ "$http_code" != "$successful_status_code" && "$http_code" != "400" && "$http_code" != "204" ]]; then
    echo "http_code was - $http_code"
    exit 1
else
    echo "http_code was - $http_code"
fi

echo "API output is:\n$apiOutput"

apiPostOutput=$(curl --request POST -sL -H "Content-Type:multipart/form-data" -F "path=/$qbee_directory/" -F "file=@$local_directory$filename" \
   --url 'https://www.app.qbee.io:9443/api/v2/file'\
   --header 'Authorization: Bearer '"$token"\
   -w "\n{\"http_code\":%{http_code}}\n")

echo 'POST request'
echo $apiPostOutput
post_http_code=$(echo $apiPostOutput | jq -cs | jq -r '.[1].http_code')
echo $post_http_code

if [ "$post_http_code" != "$successful_status_code" ]

then
    echo "http_code was - $post_http_code"
    exit 1
:
else
    echo "http_code was - $post_http_code"
fi

echo "API Post output is:\n$apiPostOutput"

echo "::set-output name=token::$token"