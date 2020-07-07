#!/bin/bash
###############################################
# Filename    :   ascii_signature.sh
# Author      :   PedroQin
# Email       :   constmyheart@163.com
# Date        :   2020-07-05 20:43:28
# Description :   Add translate punctuation mark 
# Version     :   1.0.1
# Date        :   2019-12-11 08:23:03
# Description :   
# Version     :   1.0.0
###############################################
 

whereami=`cd $(dirname $0);pwd`

# DEBUG 1
# INFO  2
# WARN  3
# ERROR 4
LOG_LEVEL=4
# will not source ASCII Art when noinit=1
NOINIT=0

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
    
    if [ $LOG_LEVEL -le $print_level ] ;then
        case $print_level in 
            1)
            echo "$@"
            ;;
            2)
            # green
            echo -e "\033[32m$@\033[0m"
            ;;
            3)
            # yello
            echo -e "\033[33m$@\033[0m"
            ;;
            4)
            # red
            echo -e "\033[31m$@\033[0m"
            ;;
        esac
    fi

}

function translate_punctuation()
{
    case "$1" in
        [a-zA-Z0-9])
        echo "char_$1"
        ;;

        \ )
        echo "char_space"
        ;;
        
        \!)
        echo "char_exclamation_mark"
        ;;

        \+)
        echo "char_plus"
        ;;

        \-)
        echo "char_minus"
        ;;

        \.)
        echo "char_period"
        ;;

        \,)
        echo "char_comma"
        ;;

        \:)
        echo "char_colon"
        ;;

        \;)
        echo "char_semicolon"
        ;;

        \?)
        echo "char_question_mark"
        ;;

        \*)
        echo "char_asterisk"
        ;;

        \_)
        echo "char_underscore"
        ;;

        \')
        echo "char_single_quotation_marks"
        ;;

        \")
        echo "char_double_quotation_marks"
        ;;

        \()
        echo "char_parenthesis_l"
        ;;

        \))
        echo "char_parenthesis_r"
        ;;

        \[)
        echo "char_square_brackets_l"
        ;;

        \])
        echo "char_square_brackets_r"
        ;;

        \<)
        echo "char_Angle_brackets_l"
        ;;

        \>)
        echo "char_Angle_brackets_r"
        ;;

        \{)
        echo "char_curly_brackets_l"
        ;;

        \})
        echo "char_curly_brackets_r"
        ;;

        \&)
        echo "char_ampersand"
        ;;

        \/)
        echo "char_slash"
        ;;

        \|)
        echo "char_vertical_bar"
        ;;

        \\)
        echo "char_backslash"
        ;;

        \~)
        echo "char_tilde"
        ;;

        \@)
        echo "char_at"
        ;;

        \#)
        echo "char_pound_sign"
        ;;

        \$)
        echo "char_dollar"
        ;;

        \%)
        echo "char_percent"
        ;;

        \^)
        echo "char_Caret"
        ;;

        *)
        return
        ;;

    esac
}

function combining_str()
{
    chars="$1"
    # get height
    height=`echo "$char_A"|wc -l`
    for i in `seq 1 $height`;do
        for ii in `seq 0 $[ ${#chars} - 1 ]`; do
            char=`translate_punctuation "${chars:$ii:1}"`
            [ -n "$char" ] && echo -n "$(echo "${!char}"|sed -n  "$i"p)"
        done
        echo
    done
}

function integrated_font()
{
    #    ____ ____ ____ 
    #   ||1 |||2 |||3 ||
    #   ||__|||__|||__||
    #   |/__\|/__\|/__\|
    if [ "$font" == "bubble" ];then
        template="  _  
 / \\ 
( 1 )
 \\_/ "
    elif [ "$font" == "smkeyboard" -o "$font" == "default" ];then
        template=" ____ 
||1 ||
||__||
|/__\\|"
    fi
    # length - 1
    local char_num=$[${#string}-1]
    local char2art=()
    local height=`echo "$template"|wc -l`
    for i in `seq 0 $char_num`; do
        char="${string:$i:1}"
        char2art[$i]="$(echo "$template"|tr 1 "$char")"
    done
    for i in `seq 1 $height`;do
        for ii in `seq 0 $char_num`; do
            echo -n "$(echo "${char2art[$ii]}"|sed -n  "$i"p)"
        done
        echo
    done
    exit 
}

function list_fonts()
{
    all_fonts="smkeyboard(default)  bubble"
    if [ ! -d "$whereami/font" ];then
        print_log 3 "Can't find $whereami/font"
    else
        for ii in `ls "$whereami/font"`;do
            all_fonts="$all_fonts  $ii"
        done
    fi
    echo "$all_fonts"
    exit 0
}

function usage()
{
    cat <<!
usage:
    ./ascii_signature.sh --font|-f \$font --str|-s \$string     do work
                         --list|-l                              list all supported font
                         --debug|-d \$LOG_LEVEL                 set the LOG_LEVEL, which level log can be display
                         --noinit|-n                            the source action need some time to execute, if you use this tool 
                                                                frequently in seconds, you may need use this para : do not source
                                                                dictionaries every time, source it before you use this tool !
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
        
        --debug|-d)
        shift
        if [ -n "$1" ] && isdigit $1 ;then
            LOG_LEVEL="$1"
        else
            LOG_LEVEL=1
            print_log 3 "Wrong log level, use default level 1"
        fi
        ;;

        # the source action need some time to execute, if you use this tool frequently in seconds , you may need use this para : do not source dictionaries every time, source it before you use this tool !
        --noinit|-n)
        NOINIT=1
        ;;

        *)
        usage
        ;;
    esac
    shift
done

font=${font:-default}
[ -z "$string" ] && usage

[ $NOINIT -eq 1 ] && print_log 2 "Set noinit, Will not source the dictionary !"
### begin
# get font
if [ ! -f "$whereami/font/$font" ] && [ "$font" != "smkeyboard" -a "$font" != "default" -a "$font" != "bubble" ];then
    print_log 4 "Can't find the font: $font. The following options are available: 
    `list_fonts`"
    exit 1
else
    print_log 1 "font: $font    string: $string"
    [ $NOINIT -eq 0 ] && { [ "$font" == "smkeyboard" -o "$font" == "default" -o "$font" == "bubble" ] && integrated_font || . "$whereami"/font/$font ; }
fi
# combining string
combining_str "$string"
