#!/usr/bin/env bash

#(^|[[:space:]])$2($|[[:space:]])

function contains() {
    if [[ "$1" =~ (^|[[:space:]])$2($|[[:space:]]) ]]; then
        echo "good"
    else
        echo "nope"
    fi
}

function myfa(){ 
    

    TARGETDIR=$(realpath "$SOURCE/$TARGET");
    TARGETDIR="$TARGETDIR/$1";
    SOURCEDIR="$SOURCE/$1";

    #echo "$1: $SOURCEDIR $TARGETDIR"
    
    if [[ ! -d  "$TARGETDIR" ]]; then
        mkdir "$TARGETDIR"     
    fi

    TARGETDIR=$(realpath "$TARGETDIR");
    
    #find "$SOURCEDIR" -type f -name $2; 

    for filename in $(find "$SOURCEDIR" -type f -name $2 -printf "%f " 2> /dev/null); do
        #echo "-file- $filename"

        COPY="NO"

        if [[ -e "$TARGETDIR/$filename" ]]; then 
            
            if [  "$SOURCEDIR/$filename" -nt "$TARGETDIR/$filename" ]; then
                #echo "cc $filename"
                COPY="YES"
            fi

        else
            #echo "nn $filename"
            COPY="YES"
        fi

        #echo "jj $filename $COPY"

        if [[ "YES" == "$COPY" ]]; then
            echo "COPY $SOURCEDIR/$filename -> $TARGETDIR/$filename"
            cp "$SOURCEDIR/$filename" "$TARGETDIR/$filename" 
        fi

    done
    

}

VALID=$(contains "PUSH PULL" "$1")

MYDIR="$( cd "$(dirname "$0")" ; pwd -P )"
#echo "--->$VALID: $MYDIR"

OK=0

if [ "nope" == $VALID ]; then
    echo "invalid direction specified";
else

    if [ -z "$2" ]; then 
        echo "NO TARGET SPECIFIED"
    else
        if [[ "PUSH" == "$1" ]]; then
            SOURCE=$MYDIR
            TARGET=$2
        else
            SOURCE=$2
            TARGET=$MYDIR
        fi
        OK=1
    fi
fi

if [[ 1 -eq $OK ]]; then

    #echo "FROM $SOURCE TO $TARGET";

    myfa "_layouts" "*.html"
    myfa "assets" "*.*"
    myfa "_sass" "*.scss"
    myfa "_includes" "*.html"


fi
