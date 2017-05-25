#!/bin/bash

if test "$1" = "-h"
then
  echo Command mail_sender
  echo Short help
  echo Usage  
  echo $0 USER1 [USER2...] \< MESSAGE
  echo Send a message to one or more allowed users
  exit 0
fi

if [ "$#" = "0" ] ; then
    echo usage error
    echo no user to be delivered
    echo type \'$0 -h\' for help
    exit 1
fi

# GETTING ADDRESSES
ADDRESS_LIST=$*

# GET MESSAGE FROM STD
MESSAGE=`cat`
if [ "$MESSAGE" = "" ] ; then
    echo usage error
    echo empty message 
    echo type \'$0 -h\' for help
    exit 1
fi

# SENDING MESSAGE
if [ "$ADDRESS_LIST" = "" ] ; then
    echo usage error
    echo no available mail-addresses
    echo type \'$0 -h\' for help
    exit 1
fi

mail -s 'bibliography message' $ADDRESS_LIST << EOF
   $MESSAGE
EOF

#$BIN/log_update    mail sent to $ALLOWED_USER_LIST

exit 0 

