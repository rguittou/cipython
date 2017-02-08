#!/bin/bash

###########################################################################
#
#	Shell program to Create a Structured Python Project Repository.
#
#	Copyright © 2017, Rabah GUITTOUNE.
#	<rabahguittoune@gmail.com>
#
#	This program is free software; you can redistribute it and/or
#	modify it under the terms of the GNU General Public License as
#	published by the Free Software Foundation; either current version of the
#	License, or  any later version. 
#
#	This program is distributed in the hope that it will be useful, but
#	WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#	General Public License for more details. 
#
#
#	Description:
#
#	This program create a repository tree for Python Project.
#
#	Usage:
#		csppr [ -h | --help ] [ [ -c | --create ] ]
#
#	Options:
#
#		-h, --help	 Display this help message and exit.
#		-c, --create Create the tree of the project repository. This
#				includes a one line description of the
#				script, its command line options and
#				arguments.
#
#	Revisions:
#
#	09/02/2017	File created
#
#	$Id: csppr,v1.0 09/02/2017 13:57:15 
###########################################################################


#       -------------------------------------------------------------------
#       Constants
#       -------------------------------------------------------------------

        PROGNAME=$(basename $0)
        VERSION="1.0.0"
		WORKING_DIR=`pwd`


#       -------------------------------------------------------------------
#       Functions
#       -------------------------------------------------------------------


function int_exit
{
	#####
	#	Function to perform exit if interrupt signal is trapped
	#	No arguments
	#####

	echo "${PROGNAME}: Aborted by user"
	exit
}

function ask_yes_no
{
	#####
	#	Function to ask a yes/no question
	#	Arguments:
	#		1	prompt string (optional)
	#####

	local yn=

	while [ "$yn" = "" ]; do
		echo -en "$1"
		read yn
		case $yn in
			y|Y)	yn=0 ;;
			n|N)	yn=1 ;;
			*)	yn=
				echo "Invalid response - please answer y or n"
				;;
		esac
	done
	return $yn
}



function clean_up
{

#       -----------------------------------------------------------------------
#       Function to remove temporary files and other housekeeping
#               Arguments: repo_name
#       -----------------------------------------------------------------------

        rm -Rf $1
}



function error_exit
{

#       -----------------------------------------------------------------------
#       Function for exit due to fatal program error
#               Accepts 1 argument:
#                       string containing descriptive error message
#       -----------------------------------------------------------------------

        echo "${PROGNAME}: ${1:-"Unknown Error"}" >&2
        exit 1
}


function graceful_exit
{

#       -----------------------------------------------------------------------
#       Function called for a graceful exit
#               No arguments
#       -----------------------------------------------------------------------

        exit
}


function signal_exit
{

#       -----------------------------------------------------------------------
#       Function to handle termination signals
#               Accepts 1 argument:
#                       signal_spec
#       -----------------------------------------------------------------------

        case $1 in
                INT)    echo "$PROGNAME: Program aborted by user" >&2
                        exit
                        ;;
                TERM)   echo "$PROGNAME: Program terminated" >&2
                        exit
                        ;;
                *)      error_exit "$PROGNAME: Terminating on unknown signal"
                        ;;
        esac
}



function create_repo
{

#       -----------------------------------------------------------------------
#       Function to create repository and set permission
#               arguments: repo_name
#       -----------------------------------------------------------------------

	mkdir $1|| error_exit "Cannot write directory ${module_name}"
	chmod 755 $1 || error_exit "Unable to set permissions on ${module_name} directory"
}


function overwrite_repo
{

#       -----------------------------------------------------------------------
#       Function to create repository and set permission
#               arguments: repo_name
#       -----------------------------------------------------------------------

	mkdir $1|| error_exit "Cannot write directory ${module_name}"
	chmod 755 $1 || error_exit "Unable to set permissions on ${module_name} directory"
}

function overwrite_repo
{

#       -----------------------------------------------------------------------
#       Function to create repository and set permission
#               arguments: repo_name
#       -----------------------------------------------------------------------
        clean_up $1
        create_repo $1
}


function create_module
{

#       -----------------------------------------------------------------------
#       Function to create module repository
#               arguments: module_name
#       -----------------------------------------------------------------------

                module_name=$1

                # Expect one arg.
                ARGCOUNT=1
                if [ $# -ne "$ARGCOUNT" ];then

                        error_exit "Syntax error:--create option need exactly one argument Report to the help  "
                fi

                # See if module_name dir already exists

                if [ -e "${module_name}" ] ; then
                        # Make sure it's a regular directory
                        if [ -d "${module_name}" ] ; then
                                # Is it writable?
                                if [ -w "${module_name}" ]; then
                                        # Confirm overwrite
                                        if ask_yes_no "Module exists - Overwrite? [y/n] " ; then
                                                overwrite_repo ${WORKING_DIR}/${module_name}
                                        fi
                                else
                                        error_exit "${module_name} is not writable"
                                fi
                        else
                                error_exit "${module_name} is not a regular directory"
                        fi
                else
                        # Try and write it
                        create_repo ${WORKING_DIR}/${module_name}
                fi

}


function create_file
{

#       -----------------------------------------------------------------------
#       Function to create readme files
#               Arguments: file_name
#       -----------------------------------------------------------------------

        # Use user's local tmp directory if it exists

        if [ -d ~/tmp ]; then
                TEMP_DIR=~/tmp
        else
                TEMP_DIR=/tmp
        fi

        # Temp file for this script, using paranoid method of creation to
        # insure that file name is not predictable.  This is for security to
        # avoid "tmp race" attacks.  If more files are needed, create using
        # the same form.

        TEMP_FILE1=$(mktemp -q "${TEMP_DIR}/${PROGNAME}.$$.XXXXXX")
        if [ "$TEMP_FILE1" = "" ]; then
                error_exit "cannot create temp file!"
        fi
}

function create_license
{

#       -----------------------------------------------------------------------
#       Function to create readme files
#               No arguments
#       -----------------------------------------------------------------------

        # Use user's local tmp directory if it exists

        if [ -d ~/tmp ]; then
                TEMP_DIR=~/tmp
        else
                TEMP_DIR=/tmp
        fi

        # Temp file for this script, using paranoid method of creation to
        # insure that file name is not predictable.  This is for security to
        # avoid "tmp race" attacks.  If more files are needed, create using
        # the same form.

        TEMP_FILE1=$(mktemp -q "${TEMP_DIR}/${PROGNAME}.$$.XXXXXX")
        if [ "$TEMP_FILE1" = "" ]; then
                error_exit "cannot create temp file!"
        fi
}

function create_readme
{

#       -----------------------------------------------------------------------
#       Function to create readme files
#               No arguments
#       -----------------------------------------------------------------------

        # Use user's local tmp directory if it exists

        if [ -d ~/tmp ]; then
                TEMP_DIR=~/tmp
        else
                TEMP_DIR=/tmp
        fi

        # Temp file for this script, using paranoid method of creation to
        # insure that file name is not predictable.  This is for security to
        # avoid "tmp race" attacks.  If more files are needed, create using
        # the same form.

        TEMP_FILE1=$(mktemp -q "${TEMP_DIR}/${PROGNAME}.$$.XXXXXX")
        if [ "$TEMP_FILE1" = "" ]; then
                error_exit "cannot create temp file!"
        fi
}

function usage
{

#       -----------------------------------------------------------------------
#       Function to display usage message (does not exit)
#               No arguments
#       -----------------------------------------------------------------------

        echo "Usage: ${PROGNAME} [-h | --help]"
}


function helptext
{

#       -----------------------------------------------------------------------
#       Function to display help message for program
#               No arguments
#       -----------------------------------------------------------------------

        local tab=$(echo -en "\t\t")

        cat <<- -EOF-

        ${PROGNAME} ver. ${VERSION}
        This is a program to aa.

        $(usage)

        Options:

        -h, --help      Display this help message and exit.




-EOF-
}


#       -------------------------------------------------------------------
#       Program starts here
#       -------------------------------------------------------------------

##### Initialization And Setup #####

# Set file creation mask so that all files are created with 600 permissions.

umask 066


# Trap TERM, HUP, and INT signals and properly exit

trap "signal_exit TERM" TERM HUP
trap "signal_exit INT"  INT


##### Command Line Processing #####

if [ "$1" = "--help" ]; then
        helptext
        graceful_exit
fi

if [ "$1" = "--create" ]; then
        create_module $2
        graceful_exit
fi
while getopts ":h" opt; do
        case $opt in

                h )     helptext
                        graceful_exit ;;
				c )     create_module
                        module_name=$2 ;;		
                * )     usage
                        exit 1
        esac
done


##### Main Logic #####
echo "voila le programme que je vais tester"
graceful_exit

