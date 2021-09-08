#!/bin/sh -l

echo "init token $1 TARNAME $TARNAME DIRNAME $DIRNAME"
apiOutput=$(curl -i --request "DELETE" -d "path=/$DIRNAME/$TARNAME" -H "Content-type: application/x-www-form-urlencoded" \
   --url 'https://www.app.qbee.io:9443/api/v2/file'\
   --header 'Authorization: Bearer '"$1")
echo "API output is:\n$apiOutput"

apiOutput=$(curl -i --request POST -H "Content-Type:multipart/form-data" -F "path=/$DIRNAME/" -F "file=@./tar/$TARNAME" \
   --url 'https://www.app.qbee.io:9443/api/v2/file'\
   --header 'Authorization: Bearer '"$1")
echo "API output is:\n$apiOutput"

echo "Hello $1"
time=$(date)
echo "::set-output name=token::$1"