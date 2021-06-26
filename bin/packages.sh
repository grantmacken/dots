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

function appInstall(){
appName=$1
    echo -n "$(check) check if $(hiLight ${appName}) is installed?" 
    if dnf list installed ${appName} &>/dev/null
    then 
      echo $(yep)
    else
      echo $(nope)
      echo -n "$(check) check if $(hiLight ${appName}) is available?" 
      if dnf list available ${appName} &>/dev/null
      then
        echo $(yep)
        dnf install -y  "${appName}"
      else
       echo $(nope)
      fi
      #echo  "$(check) $(eopkg check  ${appName})"
    fi
}

echo "TASK! install some apps using solus package manager"
for i in ${!appList[@]}
do
    appInstall "${appList[${i}]}"
  done


