#!/bin/bash

# SOURCE COMMON ENVIRONMENT VARIABLES
.  $BIBLIOGRAPHY/conf/common_env


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

PEOPLE=$*


# GET MESSAGE FROM STD

MESSAGE=`cat`
if [ "$MESSAGE" = "" ] ; then
    echo usage error
    echo empty message 
    echo type \'$0 -h\' for help
    exit 1
fi



# CHECKING USER AND GETTING ADDRESSES

ADDRESS_LIST=
ALLOWED_USER_LIST=

for USERNAME in $PEOPLE
do 
    if  `$BIN/check_user -u $USERNAME` ; then
        NEW_ADDRESS=`$BIN/check_user -m -u $USERNAME`
        ADDRESS_LIST=`echo $ADDRESS_LIST $NEW_ADDRESS`
        ALLOWED_USER_LIST=`echo $ALLOWED_USER_LIST $USERNAME`
    else
        echo $USERNAME: not an allowed user
    fi
done




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

