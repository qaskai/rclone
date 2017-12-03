
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


#download and unzip
cd ~
download_link="https://beta.rclone.org/rclone-beta-latest-$OS-$OS_type.zip"
curl -O $download_link
rclone_zip="rclone-beta-latest-$OS-$OS_type.zip"
unzip_dir="tmp_unzip_dir_for_rclone_beta"
unzip -a $rclone_zip -d $unzip_dir 
cd $unzip_dir
rclone_dir=`ls`

#mounting rclone to enviroment

cd $rclone_dir
case $OS in
  'linux')
    #binary
    mv rclone /usr/bin/
    chmod 755 /usr/bin/rclone
    chown root:root /usr/bin/rclone
    #manuals
    mkdir -p /usr/local/share/man/man1
    cp rclone.1 /usr/local/share/man/man1/
    mandb
    ;;
  'freebsd'|'openbsd'|'netbsd')
    #bin
    mv rclone /usr/bin/
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
    mv rclone /usr/local/bin/
    #manual
    mkdir -p /usr/local/share/man/man1
    cp rclone.1 /usr/local/share/man/man1/    
    ;;
  *)
    echo 'OS not supported'
    exit 1
esac

#cleanup
cd ~
rm -rf $unzip_dir $rclone_zip

echo
echo 'Now run "rclone config" for setup. Check https://rclone.org/docs/ for more details.'
echo
exit 0
