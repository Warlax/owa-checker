import re
import mechanize
import sys
from Growl import *

class OwaChecker:

    def __init__(self, url, username, password, useGrowl=True):
        self.url = url
        self.username = username
        self.password = password
        self.useGrowl = useGrowl

    def check(self):
        
        br = mechanize.Browser()
        try:

            br.open(self.url)
        except Exception:
            # No connectivity
            return -2
            
        br.select_form(name="logonForm")
        br["username"] = self.username
        br["password"] = self.password

        response = br.submit()
        html = response.read()

        if html.find('is not valid') != -1:
            # Wrong username or password
            return -1
        else:
        
            html = html[html.find('alt="">Inbox </a>') + len('alt="">Inbox </a>'):]
            html = html[:html.find('</td>')]

            unread = 0

            if html.find('<span') != -1:
                html = html[len('<span class="unrd">('):]
                html = html[:html.find(')')]
                unread = int(html)

            if self.useGrowl and unread > 0:
                message = 'You have ' + str(unread) + ' unread email'
                if unread > 1:
                    message += 's'
                message += ' in your inbox'
                growl = GrowlNotifier('OWA Checker', [GROWL_NOTIFICATION_STICKY])
                growl.register()
                growl.notify(GROWL_NOTIFICATION_STICKY, "Unread Email", message)
                
            return unread
        
if __name__ == '__main__':

    args = sys.argv
    if len(args) != 4:
        print 'usage: OWA-ADDRESS EMAIL PASSWORD'
        print '\tExample: https://mymail.company.com/owa edwin@company.com great123'
    else:
        print 'Communicating with OWA, please wait...'
        
        url = args[1]
        user = args[2]
        password = args[3]

        owa = OwaChecker(url, user, password)
        unread = owa.check()

        if unread == -1:
            print 'Wrong username or password'
        elif unread == -2:
            print 'Could not connect to ' + url
        else:
            print 'You have ' + str(unread) + ' unread emails in your inbox'
