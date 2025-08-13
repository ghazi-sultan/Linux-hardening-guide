#!/bin/bash
# check_users.sh
# A simple script to list all currently logged-in users and their details

echo "====================================="
echo " Currently Logged-In Users"
echo "====================================="
who

echo
echo "====================================="
echo " Detailed User Session Information"
echo "====================================="
w
