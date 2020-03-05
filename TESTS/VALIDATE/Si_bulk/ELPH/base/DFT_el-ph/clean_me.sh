#!/bin/bash
find . | grep -v 'launch_me' | grep -v 'clean_me'  |grep -v '.svn' | grep './' | xargs rm -fr
