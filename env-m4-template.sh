#!/bin/bash
# env-m4-template.sh - Process m4 templates with env file data
# Usage: ./env-m4-template.sh data.env template.m4

# Example setup:
# 
# data.env:
#   USER=Alice
#   PROJECT=WebApp
#   VERSION=2.1.0
#
# main.m4:
#   Welcome to $PROJECT version $VERSION!
#   include(`header.m4')
#   
# header.m4:
#   === Deployed by $USER ===
#   include(`build/info.m4')
#
# build/info.m4:
#   Build details for $PROJECT v.$VERSION
#
# Result:
#   Welcome to WebApp version 2.1.0!
#   === Deployed by Alice ===
#   Build details for WebApp v.2.1.0

# First, expand all includes to create a flat template
m4 "$2" > temp_expanded.m4 2>/dev/null

# Then use envsubst with the env file for variable substitution
set -a  # Export all variables
source "$1"
set +a
envsubst < temp_expanded.m4