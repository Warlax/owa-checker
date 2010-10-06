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

python owa.py $URL $USERNAME $PASSWORD
