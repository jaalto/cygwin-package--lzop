#!/bin/sh
#
# install-after.sh -- Custom installation
#
# The script will receive one argument: relative path to
# installation root directory. Script is called like:
#
#    $ install-after.sh .inst
#
# This script is run after [install] command.

Cmd()
{
    echo "$@"
    [ "$test" ] && return
    "$@"
}

Main()
{
    root=${1:-".inst"}

    if [ "$root"  ] && [ -d $root ]; then

        root=$(echo $root | sed 's,/$,,')  # Delete trailing slash
        docdir=$(cd $root/usr/share/doc/lzop-* && pwd)

        #  For some reason the install process copies files
        #  as symlinks to docdir.

        echo "... Unbreaking the symlinks and using real files"

        for file in $docdir/*
        do
          [ -h $file ] || continue

          #  Remove symlinks and copy real files
          Cmd cp $file $file.tmp
          Cmd rm $file
          Cmd mv $file.tmp $file
        done
    fi
}

Main "$@"

# End of file
