#!/bin/sh
#################################################################################
# Copyright (c) 2010, Alejandro Nijamkin
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
# 
# Redistributions of source code must retain the above copyright notice, this 
# list of conditions and the following disclaimer.
# Redistributions in binary form must reproduce the above copyright notice, this 
# list of conditions and the following disclaimer in the documentation and/or 
# other materials provided with the distribution.
# Neither the name Alejandro Nijamkin nor the names of its contributors may 
# be used to endorse or promote products derived from this software without 
# specific prior written permission.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#################################################################################
EXPECTED_ARGS=3

USER_DIR=/Users/Ale
GROWL_NOTIFY_PATH=/usr/local/bin
. $USER_DIR/.bash_profile

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: URL USERNAME PASSWORD"
  exit
fi

URL=$1
USERNAME=$2
PASSWORD=$3

#echo "Running curl..."
CURL=$(curl --silent --cookie-jar cookies.txt --location --data "destination=$1&flags=4&forcedownlevel=0&trusted=4&username=$2&password=$3&isUtf8=1" $1/owa/auth/owaauth.dll)
#echo "...done"

count=0

if [[ $CURL == *"not valid"* ]]
then
	count=-1
	${GROWL_NOTIFY_PATH}/growlnotify --name "OWA Checker" --title "OWA Checker" --message "Invalid username and/or password!" --appIcon Mail.app
else
	#echo "Parsing HTTP response..."
	if [[ $CURL == *">Inbox </a><span class=\"unrd\">"* ]]
	then
		CURL=$(echo $CURL | sed 's/.*class="unrd">//' | sed 's/<.*//' | tr -d "\n" | tr "()" "^")
		if [[ $CURL == *"^"* ]]
		then
			CURL=$(echo $CURL | tr -d "^")
			count=$CURL
			emails="email."
			if [ $count -gt 1 ]
			then
				emails="emails."
			fi
			${GROWL_NOTIFY_PATH}/growlnotify --name "OWA Checker" --title "OWA Checker" --message "You have ${count} unread ${emails}" --appIcon Mail.app
		fi
    fi
	#echo "...done"
fi
