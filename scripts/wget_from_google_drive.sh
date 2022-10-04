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

# This is the unique ID of the specific sheet within ID_spread we want to get
ID_single_sheet="0"

# Name of the .csv output file
csv_out="control_room.csv"

# Calling wget
wget --output-file="control_room.log" "$link/$ID_spreadsheet/export?format=csv&gid=$ID_single_sheet" -O "$csv_out"
