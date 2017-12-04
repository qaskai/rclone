#!/bin/sh
set -e

usage() { echo "Usage: curl https://rclone.org/install.sh | sudo bash [-s beta]" 1>&2; exit 1; }

#check for beta flag
if [ -n "$1" ] && [ "$1" != "beta" ]; then
    usage
fi

#detect the platform
OS="`uname`"
case $OS in
  Linux)
    OS='linux'
    ;;
  FreeBSD)
    OS='freebsd'
    ;;
  NetBSD)
    OS='netbsd'
    ;;
  OpenBSD)
    OS='openbsd'
    ;;  
  Darwin)
    OS='osx'
    ;;
  SunOS)
    OS='solaris'
    echo 'OS not supported'
    exit 1
    ;;
  *)
    echo 'OS not supported'
    exit 1
    ;;
esac

OS_type="`uname -m`"
case $OS_type in
  x86_64|amd64)
    OS_type='amd64'
    ;;
  i?86|x86)
    OS_type='386'
    ;;
  arm*)
    OS_type='arm'
    ;;
  *)
    echo 'OS type not supported'
    exit 1
    ;;
esac

#create tmp directory and move to it
tmp_dir=`mktemp -d`; cd $tmp_dir

#download and unzip
if [ -z "${install_beta}" ]; then
    download_link="https://downloads.rclone.org/rclone-current-$OS-$OS_type.zip"
    rclone_zip="rclone-current-$OS-$OS_type.zip"
    echo "normal installation"
else
    download_link="https://beta.rclone.org/rclone-beta-latest-$OS-$OS_type.zip"
    rclone_zip="rclone-beta-latest-$OS-$OS_type.zip"
    echo "installing beta"
fi

curl -O $download_link
unzip_dir="tmp_unzip_dir_for_rclone"
unzip -a $rclone_zip -d $unzip_dir 
cd $unzip_dir/*

#mounting rclone to enviroment

case $OS in
  'linux')
    #binary
    cp rclone /usr/bin/
    chmod 755 /usr/bin/rclone
    chown root:root /usr/bin/rclone
    #manuals
    mkdir -p /usr/local/share/man/man1
    cp rclone.1 /usr/local/share/man/man1/
    mandb
    ;;
  'freebsd'|'openbsd'|'netbsd')
    #bin
    cp rclone /usr/bin/
    chmod 755 /usr/bin/rclone
    chown root:wheel /usr/bin/rclone
    #man
    mkdir -p /usr/local/man/man1
    cp rclone.1 /usr/local/man/man1/
    makewhatis
    ;;
  'osx')
    #binary
    mkdir -p /usr/local/bin
    cp rclone /usr/local/bin/
    #manual
    mkdir -p /usr/local/share/man/man1
    cp rclone.1 /usr/local/share/man/man1/    
    ;;
  *)
    echo 'OS not supported'
    exit 1
esac


echo
echo 'Now run "rclone config" for setup. Check https://rclone.org/docs/ for more details.'
echo
exit 0
