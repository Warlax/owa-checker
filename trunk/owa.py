import re
import mechanize
import sys

class OwaChecker:

    def __init__(self, url, username, password):
        self.url = url
        self.username = username
        self.password = password

    def check(self):
        
        br = mechanize.Browser()
        br.open(self.url)
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
                
            return unread
        

if __name__ == '__main__':

    args = sys.argv
    if len(args) != 4:
        print 'usage: URL USERNAME PASSWORD'
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
        else:
            print 'You have ' + str(unread) + ' unread emails in your inbox'
