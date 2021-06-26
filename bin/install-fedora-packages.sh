#!/bin/bash +x

############################################################
#  Program: solus packages a new Desktop
#  Author : Grant MacKenzie
#  markup.co.nz
#  grantmacken@gmail.com
#  run as sudo
#
############################################################

clear
readarray appList < $1

function yep(){
  tput setaf 2
  echo -n ' ✓ '
  tput setaf 15
}


function nope(){
  tput setaf 1
  echo -n ' ✗ '
  tput setaf 15
}

function check(){
  tput setaf 3
  echo -n ' ☂ '
  tput setaf 15
}

function hiLight(){
  tput setaf 11
  echo -n "$1"
  tput setaf 15
}


function echoLine(){
local line=$1
if [[ -z $line ]] ; then
 line='-'
fi
printf '%*s' "$(tput cols)" '' | tr ' ' ${line}
}

function appInstall(){
  echoLine
appName=$1
chkInstalled=$(
    dnf list installed ${appName} |
    grep 'Error: No matching Packages to list' 
    )
    echo "$(check) check if $(hiLight ${appName}) is installed? " 
    if [ -n "${chkInstalled}" ]; then
      echo "$(nope) ${chkInstalled}"
      chkBinRepo=$(
      dnf list available ${appName} |
      grep 'Error: No matching Packages to list' 
      )
      echo "$(check) check if $(hiLight ${appName}) is available? " 
      if [ -n "${chkBinRepo}" ]; then
       echo "$(nope) ${chkBinRepo}"
      else
        echo "$(yep)  ${appName} "
        dnf install -y  ${appName}
      fi
    else
      echo "$(yep) ${appName}"
      #echo  "$(check) $(eopkg check  ${appName})"
    fi
}

echo "TASK! install some apps using solus package manager"
for i in ${!appList[@]}
do
    appInstall "${appList[${i}]}"
  done


