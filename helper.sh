#!/bin/bash

#######################################
#######################################
#
# Notes on how to do background things
#
########################################
########################################

################
# 
# Basics
# 
################

# Install express and https
npm i express https

# Git ignore for the certs etc
echo -e "
    certs/*
" > .gitignore

# Generate self-signed cert
openssl genrsa -out key.pem
openssl req -new -key key.pem -out csr.pem
openssl x509 -req -days 9999 -in csr.pem -signkey key.pem -out cert.pem


# Start node server
node index.js

"
Server listening on port = 8000, address = 127.0.0.1

"