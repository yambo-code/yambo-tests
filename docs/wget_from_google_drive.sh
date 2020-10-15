#!/bin/bash
#
# Download contents of a specific sheet in a Google spreadsheet and store them in a .csv file
#
# [NOTE} Spreadsheet must have the following sharing permissions: 
#           "anybody with a link may visualise this document"

# This is the generic address of a google spreadsheet
link="https://docs.google.com/spreadsheets/d"

# This is the unique ID of the spreadsheet we want to read
ID_spreadsheet="1LKZy4KWIr733aWuLuhYeAFi4aMw-sgJdXSQkw1gr-5A"

# This is the unique ID of the specific sheet within ID_spread we want to get
ID_single_sheet="0"

# Name of the .csv output file
csv_out="test.csv"

# Calling wget
wget --output-file="logs.csv" "$link/$ID_spreadsheet/export?format=csv&gid=$ID_single_sheet" -O "$csv_out"
