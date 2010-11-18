#!/bin/sh
EXPECTED_ARGS=3

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: URL USERNAME PASSWORD"
  exit
fi

URL=$1
USERNAME=$2
PASSWORD=$3

CURL=$(curl --cookie-jar cookies.txt --location --data "destination=$1&flags=4&forcedownlevel=0&trusted=4&username=$2&password=$3&isUtf8=1" $1/owa/auth/owaauth.dll)

count=0

if [[ $CURL == *"not valid"* ]]
then
	count=-1
else
	if [[ $CURL == *">Inbox </a><span class=\"unrd\">"* ]]
	then
		CURL=$(echo $CURL | sed 's/.*class="unrd">//' | sed 's/<.*//' | tr -d "\n" | tr "()" "^")
		if [[ $CURL == *"^"* ]]
		then
			CURL=$(echo $CURL | tr -d "^")
			count=$CURL
		fi
    fi
fi
echo $count
