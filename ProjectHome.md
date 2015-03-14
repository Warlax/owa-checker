If your company uses OWA (Outlook Web Access) for internal email, you basically are limited to Outlook or Entourage - otherwise, you need to actively go and check email manually.  Something that I often forget to do.

The Owa Checker is a simple bash script that uses curl (installed on all Macs by default) to check your email for you.

## In the future ##
  1. I intend to build a program that can run in the background and check your email periodically -- for now I am using cron.
  1. I intend for the program to prompt you for username/password every time you start it, to keep your username and password confidential.

## For now ##
  1. I suggest using a cron job to run the .sh file every so and so minutes.

## Requirements / How To use: ##

### growlnotify ###
  1. If not already done, download and install [Growl](http://growl.info/index.php).
  1. In the downloaded disk image for Growl, you should see an Extras directory.
  1. Double-click the growlnotify.pkg installer under the growlnotify subdirectory.
### The script ###
  1. Download the script from the Downloads section.
  1. Edit owa.sh: change the line that says `USER_DIR=/Users/Ale` to point at your own home folder.
  1. change the line that says `GROWL_NOTIFY_PATH=/usr/local/bin` to point at the location where growlnotify is.
  1. Run it in one of two ways:
`$ ./owa.sh [url] [username] [password]` or:
Set up a cron job.

Example:
`$ ./owa.sh mymail.company.com dave@company.com 1234m`

**_You need your uername and password to not include the exclamation point (!) for bash to understand it._**