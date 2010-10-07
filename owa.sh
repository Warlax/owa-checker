#!/bin/sh
EXPECTED_ARGS=3
OWA_PY_PATH=/Users/Ale/Dropbox/Code/Personal/OwaNotifier/owa.py
USER_DIR=/Users/Ale

. $USER_DIR/.bash_profile
if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: URL USERNAME PASSWORD"
  exit
fi

URL=$1
USERNAME=$2
PASSWORD=$3

python $OWA_PY_PATH $URL $USERNAME $PASSWORD
