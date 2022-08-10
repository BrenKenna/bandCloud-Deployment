#!/bin/bash
######################################################################
######################################################################
#
# Script to run webserver
# 
# Ideally would things like managing logging etc
# 
#
######################################################################
######################################################################


# Run server
echo -e "\n\n\nInstalling packages"
npm i &>> /dev/null
cd bandCloud-frontend
npm i &>> /dev/null
npm i cookie-parser &>> /dev/null
echo -e "\n\n\nInstallation complete\\nStarting up web server\n"
node dist-server.js