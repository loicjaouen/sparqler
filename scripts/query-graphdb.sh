#! /usr/bin/env bash
#ubrs# env bash is more portable, read http://bashcookbook.com/ recipe 15.1

###############################################################################

#
# name this script
#
# describe the script
#

#ubrs# note : generate your barebone script from this boiler plate:
#ubrs#        grep '# note @ubrs:' boilerplate > myscript
#ubrs#        chmod +x myscript 

###############################################################################

# sanity checks
# exit when a command fails, use "cmd || true" to allow "cmd" to fail
# comment this out is you need to know that it failed
set -o errexit
# don't allow undeclared variables
set -o nounset
# exit on pipe failure (cmd1 | cmd2 : exits if cmd2 fails)
set -o pipefail
# comment xtrace when not in debug
set -o xtrace

###############################################################################

# check user
#ubrs# this is for sysadmin, isn't it?
#ubrs# tests: prefer `[[` to `[` for readability, no escape for `(`, use `&&`,
#ubrs#        no word splitting for strings, pattern matchin
#ubrs#        ref: https://mywiki.wooledge.org/BashFAQ/031
#if [[ $EUID -ne 0 ]]; then
#  echo "Please run as root"
#  exit 1
#fi

###############################################################################

# helper functions

###############################################################################

# functions script specific functions

#ubrs# note: when a function is called, it's not clear that it is a function is a
#ubrs#       function, use a prefix
function do-onetwo {
    #ubrs# function returning a string value via `echo`
    echo "one two"
    return 0
}

#ubrs# note: using bash is not a reason to not test
function test-onetwo {
    #ubrs# call methods directly and let them use stdout/err
    do-onetwo
    #ubrs# or capture the echoed output
    #ubrs# use local var `$_` for temporary result
    local _=$( do-onetwo )
    #ubrs# check return values as content
    if [[ $( do-onetwo ) != "one two" ]]; then
        exit 1
    fi
    #ubrs# funky things
    if [[ $( do-onetwo ) != *two ]]; then
        exit 1
    fi
    #ubrs# test returned values
    if ! do-onetwo; then
        exit 1
    fi
    #ubrs# test meaningful non 0 results
    local _=$( do-onetwo )
    if [[ $? -eq 3 ]]; then
        exit 1
    fi
}

function test-parse_args {
    # test parsing with these args
    # expected: FLAG_HELP=0, FLAG_VERBOSE=1,
    #           ARG_FILENAME=filename, ARG_GOAL=""
    do-parse_args -h -f=filename --config=test.config

    if [[ "${FLAG_HELP}" -eq 0 ]]; then
        echo "FLAG_HELP: ${FLAG_HELP}"
    else
        exit 1
    fi

    if [[ "${FLAG_VERBOSE}" -eq 1 ]]; then
        echo "FLAG_VERBOSE: ${FLAG_VERBOSE}"
    else
        exit 1
    fi
    
    if [[ "${ARG_FILE}" == "filename" ]]; then
        echo "ARG_FILE: ${ARG_FILE}"
    else
        exit 1
    fi
    
    if [[ -n "${ARG_GOAL}" ]]; then
        echo "ARG_GOAL: ${ARG_GOAL}"
    else
        exit 1
    fi

    if [[ "$CONFIG_A" == "a" && "$CONFIG_B" == "bb" && "$CONFIG_C" == "$(hostname)" && -z "$CONFIG_D" ]]; then
        echo "config: $CONFIG_A, $CONFIG_B, $CONFIG_C, ${CONFIG_D}###"
    else
        exit 1
    fi
    
}

###############################################################################

# helper functions

function do-tests {
    test-parse_args 
    test-onetwo
}

function do-main {
    echo "doing things about ${ARG_VAL}"
}

function do-parse_args {
    ARG_CONFIG=
    for i in "$@"; do
        case $i in
            # flags
            -v|--verbose)
            FLAG_VERBOSE=0
            ;;
            -h|--help)
            FLAG_HELP=0
            ;;
            # arguments
            -f=*|--file=*)
            ARG_FILE="${i#*=}"
            shift
            ;;
            -g=*|--goal=*)
            ARG_GOAL="${i#*=}"
            shift
            ;;
            -c=*|--config=*)
            ARG_CONFIG="${i#*=}"
            shift
            ;;
            *)
                # unknown option
            ;;
        esac
    done

    if [[ -n "$ARG_CONFIG" ]]; then
        if [[ -r $ARG_CONFIG ]]; then
            source $ARG_CONFIG
        else
            echo "ERROR: fichier de config non lisible ou non existant ($ARG_CONFIG)"
            exit 1
        fi
    fi
}
###############################################################################

# main

# delegate the argument parsing to `do-parse`
FLAG_VERBOSE=1
FLAG_HELP=1
ARG_FILE=
ARG_GOAL=
do-parse_args $@

# run tests if asked
if [[ $# -gt 0 && $1 == "runtests" ]]; then
    #ubrs# prefix should help knowing it is a function call
    do-tests
else
    do-main
fi

#ubrs# last line: being optimistic, exit with the successful
exit 0
