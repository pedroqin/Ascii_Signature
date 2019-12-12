#!/bin/bash
###############################################
# Filename    :   ascii_signature.sh
# Author      :   PedroQin
# Email       :   pedro.hq.qin@mail.foxconn.com
# Date        :   2019-12-11 08:23:03
# Description :   
# Version     :   1.0.0
###############################################
 

whereami=`cd $(dirname $0);pwd`

# DEBUG 1
# INFO  2
# WARN  3
# ERROR 4
log_level=4

function isdigit()
{
    local str=
    for str in $@
    do
        str=$1
        while [ -n "$str" ]; do
            echo ${str:0:1} | grep "[-.0-9]" > /dev/null 2>&1
            [ $? -ne 0 ] && return 27
            str=`echo ${str:1}`
        done
        shift
    done
    return 0
}

function print_log()
{
    if isdigit $1 ;then
        print_level=$1
        shift
    else
        # default log level
        print_level=1
    fi
    
    if [ $log_level -le $print_level ] ;then
        case $print_level in 
            1)
            echo "$@"
            ;;
            2)
            echo -e "\033[32m$@\033[0m"
            ;;
            3)
            echo -e "\033[33m$@\033[0m"
            ;;
            4)
            echo -e "\033[31m$@\033[0m"
            ;;
        esac
    fi

}

function combining_str()
{
    chars=`echo "$1"|grep -oE [a-z' 'A-Z0-9]`
    # get height
    height=`echo "$char_A"|wc -l`
    for ii in `seq 1 $height`;do
        for char in $chars ;do
            char=char_$char
            echo -n "$(echo "${!char}"|sed -n  "$ii"p)"
        done
        echo
    done
}

function default_font()
{
    #    ____ ____ ____ 
    #   ||1 |||2 |||3 ||
    #   ||__|||__|||__||
    #   |/__\|/__\|/__\|
    template=" ____ 
||1 ||
||__||
|/__\\|"
    for ii in {a..z} {A..Z} {0..9};do
        export char_$ii="$(echo "$template"|tr 1 $ii)"
    done
}

function list_fonts()
{
    all_fonts="smkeyboard(default)"
    if [ ! -d "$whereami/font" ];then
        print_log 3 "Can't find $whereami/font"
    else
        for ii in `ls "$whereami/font"`;do
            all_fonts="$all_fonts $ii"
        done
    fi
    echo "$all_fonts"
    exit 0
}

function usage()
{
    cat <<!
usage:
    ./ascii_signature.sh --font|-f \$font --str|-s \$string   do work
                         --list|-l                            list all supported font
!
    exit 255
}

### parameter

[ $# -eq 0 ] && usage
while [ $# -ge 1 ] ;do
    case ${1} in
        --font|-f)
        shift
        font=$1
        ;;
        --str|-s)
        shift
        string="$1"
        ;;
        --list|-l)
        list_fonts
        ;;
        *)
        usage
        ;;
    esac
    shift
done

font=${font:-default}
[ -z "$string" ] && usage

### begin
# get font
if [ ! -f "$whereami/font/$font" ] && [ "$font" != "smkeyboard" -a "$font" != "default" ];then
    print_log 4 "Can't find the font: $font. The following options are available: 
    `list_fonts`"
    
    exit 1
else
    print_log 2 "font: $font"
    [ "$font" == "smkeyboard" -o "$font" == "default" ] && default_font || . "$whereami"/font/$font
fi
print_log 1 "font: $font    string: $string"
# combining string
combining_str "$string"
