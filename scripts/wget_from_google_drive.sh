#!/bin/bash
#
# Download contents of a specific sheet in a Google spreadsheet and store them in a .csv file
#
# [NOTE} Spreadsheet must have the following sharing permissions: 
#           "anybody with a link may visualise this document"

#https://docs.google.com/spreadsheets/d/1RJCh6qqqdyaeqvX4Dh0I1ppEhCoNYMjIepXnRzxDhHk/edit?usp=sharing

# This is the generic address of a google spreadsheet
link="https://docs.google.com/spreadsheets/d"

# This is the unique ID of the spreadsheet we want to read
ID_spreadsheet="1RJCh6qqqdyaeqvX4Dh0I1ppEhCoNYMjIepXnRzxDhHk"

# Clean
rm -f control_room*

# This is the unique ID of the specific sheet within ID_spread we want to get
for ID in 0 750058484; do
 # Name of the .csv output file
 csv_out="control_room_$ID.csv"
 log_out="control_room_$ID.log"
 # Calling wget
 wget --output-file="$log_out" "$link/$ID_spreadsheet/export?format=csv&gid=$ID" -O "$csv_out"
 #
 cat $log_out >> control_room.log
 cat $csv_out >> control_room.csv
 rm -f $log_out $csv_out
done
