#!/usr/bin/env python

import smtplib

fromaddr = 'yambo@yambo-code.org'
toaddrs  = 'andrea.marini@cnr.it'

msg = "\r\n".join([
  "From: " + fromaddr,
  "To: " + toaddrs,
  "Subject: Just a message",
  "",
  "Why, oh why"
  ])

username = 'yambo@yambo-code.org'
password = 'kandela'
server = smtplib.SMTP('smtp.yambo-code.org:25')

server.ehlo()
server.starttls()
server.login(username,password)
server.sendmail(fromaddr, toaddrs, msg)
server.quit()

