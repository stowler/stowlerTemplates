#!/bin/bash
#
# LOCATION:	<location including filename>
# USAGE:	see fxnPrintUsage() function below 
#
# CREATED:	<date> by stowler@gmail.com
# LAST UPDATED:	<date> by stowler@gmail.com
#
# DESCRIPTION:
# <EDITME: description of what the script does>
# 
# SYSTEM REQUIREMENTS:
#  - awk must be installed for fxnCalc
#   <EDITME: list or describe others>
#
# INPUT FILES AND PERMISSIONS FOR OUTPUT:
# <EDITME: list or describe>
#
# OTHER ASSUMPTIONS:
# <EDITME: list or describe>
#
# READING AND CODING NOTES:
# 
# This script contains a few first-level sections, each starting with one of these headings:
# ------------------------- START: define functions ------------------------- #
# ------------------------- START: define constants ------------------------- #
# ------------------------- START: process the invocation ------------------------- #
# ------------------------- START: greet user/logs ------------------------- #
# ------------------------- START: body of script ------------------------- #
# ------------------------- START: restore environment and say bye to user/logs ------------------------- #
#
# Search for "EDITME" to find areas that may need to be edited on a
# per-system/per-experiment/per-whatever basis.
#
# Search for "TBD" to find areas where I have work to do, decisions to make, etc. TBD.
#
# Search for "DEBUG" go find areas that I only intend to execute duing debugging.
#
#
########### !!!!!!! EDITME FOR TEMPLATE ONLY. REMOVE FROM CHILD SCRIPTS: !!!!!!! ###########
# A meta note for editing this template :
#
# LOCATION: 
# https://github.com/stowler/stowlerTemplates/edit/master/bash-template-general.sh
#
# USAGE:
# bash-template-general.sh (no arguments)
# (this executes fxnSelftestBasic)
#
# ...but really this is a template from which to build other scripts:
#
# SIMPLE USE
# (no command-line arguments, no output to filesystem):
# 1) Make a copy of this template script.
# 2) Paste a list of commands into the script body. 
#    (search for "START: body of script". Paste after that.)
# 3) execute the script to run your list of commands
# 4) contemplate the ephemera of the output as it appears in your terminal
#
# INTERMEDIATE USE
# (no command-line arguments, but output something to ${tempDir} in the filesystem):
# 1) Make a copy of this template script.
# 2) Uncomment the line in the script body that calls fxnSetTempDir. This
#    creates the variable ${tempDir} and then tries to create a new ${tempDir}
#    directory in the filesystem. This will be the temporary directory to which
#    you will send your output files from this script. 
# 2) Paste a list of commands into the script body after calling fxnSetTempDir.
#    This could be pretty much anything, but be sure any output files get
#    routed to ${tempDir}. Like such:
#
#	ls -al ~ > ${tempDir}/aListOfStuffInYourHomeDirectory.txt
#	echo "Um. That's everything as of `date`" >> ${tempDir}/aListOfStuffInYourHomeDirectory.txt
#	cat ${tempDir}/aListOfStuffInYourHomeDirectory.txt
#	echo ""
#	echo "Scroll up to see a listing of the stuff in your home directory"
#	echo "as it was recorded in the recently created text file"
#	echo "called ${tempDir}/stuffInMyHomeDirectory.txt"
#	echo ""
#
# 3) Execute the script to run your list of commands.
# 4) Enjoy the ephemera appearing in the terminal window while you anticipate
#    what awaits you in ${tempDir} upon script completion. 
# 5) Open a new terminal window and cd to the folder that was created as
#    ${tempDir}. Noticing, of course, that you can't just type "cd ${tempDir}"
#    since the variable ${tempDir} wasn't exported from the script.  Once in
#    ${tempDir} issue "pwd" to confirm your location and then issue "ls" to marvel
#    at the bounty of files you have created.
# 6) Do what you like with your creations and then manually delete ${tempDir}.

#
# Design:
# - avoid references to external files  
# - include just enough internal functions so that reasonable child scripts can stand on their own.
#
# Minding pedagogy: 
# - Don't over-functionalize the template. It provides babysteps for trainees
#   who don't yet understand internal functions:
#    - banners: they're a good place for a brand-new trainee to make superficial edits and see how output is affected
#    - define constants section: trainees will learn to edit variables there even before they understand functions
#    - invocation and restoration sections: trainees will learn to create functions from these
# - Design for brand-new trainees, whose progression is likely:
#    1) run script as intended, inspect typical output
#    2) run script with intentionally bad arguments, and interpret error messages
#    3) read beginning at "START: body of script"
#    4) read beginning at "START: define constants"
#    5) read beginning at "START: define functions"
#    6) edit body of script
#    7) edit existing function definitions
#    8) write new internal functions
#    9) edit invocation
# - make sure edits are reflected in fxnSelftestBasic()
# - test with fxnSelftestBasic() after editing
# 
########### !!!!!!! EDITME FOR TEMPLATE-ONLY: REMOVE FROM CHILD SCRIPTS !!!!!!! ###########



# ------------------------- START: define functions ------------------------- #

# These are internal functions, defined in any order regardless of
# interdependencies since they're not interpreted until called from the body of
# the script:

fxnPrintUsage() {
   # EDITME: customize for each script:
   echo >&2 "$0 - a script to do something"
   echo >&2 "Usage: scriptname [-r|-n] -v file {file2 ...}"
   echo >&2 "  -r   print data rows only (no column names)"
   echo >&2 "  -n   pring column names ONLY (no data rows)"
   echo >&2 "  -v   be verbose"
}


fxnSelftestBasic() {
   # Tests the basic funcions and variables of the template on which this
   # script is based. Valid output appears as comment text at the bottom
   # of this script. This can be used to confirm that the basic functions
   # of the script are working on a particular system, or that they haven't
   # been broken by recent edits.
}


fxnCalc() {
   # fxnCalc is also something I include in my .bash_profile:
   # e.g., calc(){ awk "BEGIN{ print $* }" ;}
   # use quotes if parens are included in the function call:
   # e.g., calc "((3+(2^3)) * 34^2 / 9)-75.89"
   awk "BEGIN{ print $* }" ;
}


fxnSelftestFull() {
  # Tests the full function of the script. Begins by calling fxnSelftestBaic() , and then...
  # <EDITME: description of tests and validating data>
  fxnSelftestBasic()
}


fxnSetTempDir(){
   # Create a temporary directory ${tempDir} 
   # This will be a child of directory ${tempParent}, which maybe set prior to calling this fxn, 
   # or will be set to something sensible by this function.
   #
   # NB: ${tempParent} might need to change on a per-system, per-script, or per-experiment, basis
   #    If tempParent or tempDir needs to include identifying information from the script,
   #    remember to assign values before calling fxnSetTempDir!)
   #    e.g., tempParent=${participantDirectory}/manyTempProcessingDirsForThisParticipant && fxnSetTempDir()

   # first manage ${tempParent}: 
   # is it already defined as a writable directory? If not, try to define a reasonable one:
   tempParentPrevouslySetToWritableDir=''
   hostname=`hostname -s`
   kernel=`uname -s`
   if [ -n "${tempParent}"] && [ -d "${tempParent}" ] && [ -w "${tempParent}" ]; then
      tempParentPreviouslySetToWritableDir=1
   elif [ $hostname = "stowler-mba" ]; then
      tempParent="/Users/stowler/temp"
   elif [ $kernel = "Linux" ] && [ -d /tmp ] && [ -w /tmp ]; then
      tempParent="/tmp"
   elif [ $kernel = "Darwin" ] && [ -d /tmp ] && [ -w /tmp ]; then
      tempParent="/tmp"
   else
      echo "fxnSetTempDir cannot find a suitable parent directory in which to create a new temporary directory. Edit script's $tempParent variable. Exiting."
      exit 1
   fi

   # Now that writable ${tempParent} has been confirmed, create ${tempDir}:
   # e.g., tempDir="${tempParent}/${startDateTime}-from_${scriptName}.${scriptPID}"
   tempDir="${tempParent}/${startDateTime}-from_${scriptName}.${scriptPID}"
   mkdir ${tempDir}
   if [ $? -ne 0 ] ; then
      echo ""
      echo "ERROR: fxnSetTempDir was unable to create temporary directory ${tempDir}."
      echo 'You may want to confirm the location and permissions of ${tempParent}, which is understood as:'
      echo "${tempParent}"
      echo ""
      echo "Exiting."
      echo ""
      exit 1
   fi
}


fxnValidateImages() {
   invalidInputList=''
   for image in $@; do
      # is file a readable image?
      3dinfo $image &>/dev/null
      if [ "$?" -ne "0" ]; then
         invalidInputList="`echo ${invalidInputList} ${image}`"
      fi
   done
   if [ ! -z "${invalidInputList}" ]; then
      echo ""
      echo "ERROR: these input files do not exist or are not valid 3d/4d images. Exiting:"
      echo ""
      echo "${invalidInputList}"
      echo ""
      exit 1
   fi
}

fxnSetSomeBasicConstants() {
	# Create some constants to make basic system information convenient for
	# the script. These are technically variables but we are calling them
	# constants because their values don't change during the script.
	#
	# Here we set the value of each variable, but only if it doesn't
	# already have a value. For example: before the nominal script body I
	# assign a value to ${scriptName} so that it can appear in a welcome
	# banner, even before the call to this function. We wouldn't want to
	# overwrite the value of ${scriptName} here if it had been set to
	# something specific in the script body.
	# 
	# Performed via the if/the/else statements below for each constant:
	#
	# if the variable is empty: 
	# 	assign a value to the variable AND
	# 	add its name to the list of constants
	# else it's not empty:
	# 	it already has a value so just add its name to the list
	# 
	listOfBasicConstants=''	

	if [ -z "${scriptName}" ]; then
		scriptName="`basename $0`"
		listOfBasicConstants="scriptName ${listOfBasicConstants}"
	else
		listOfBasicConstants="scriptName ${listOfBasicConstants}"
 	fi

	if [ -z "${scriptPID}" ]; then
		scriptPID="$$"
		listOfBasicConstants="scriptPID ${listOfBasicConstants}"
	else
		listOfBasicConstants="scriptPID ${listOfBasicConstants}"
	fi

	if [ -z "${scriptUser}" ]; then
		scriptUser="`whoami`"
		listOfBasicConstants="scriptUser ${listOfBasicConstants}"
	else
		listOfBasicConstants="scriptUser ${listOfBasicConstants}"
	fi
	if [ -z "${startDate}" ]; then
		startDate="`date +%Y%m%d`"
		listOfBasicConstants="startDate ${listOfBasicConstants}"
	else
		listOfBasicConstants="startDate ${listOfBasicConstants}"
	fi
	if [ -z "${startDateTime}" ]; then
		startDateTime="`date +%Y%m%d%H%M%S`"
		listOfBasicConstants="startDateTime ${listOfBasicConstants}"
	else
		listOfBasicConstants="startDatetime ${listOfBasicConstants}"
	fi
	
	# and then list the variables we defined:
	echo "DEBUG: \${listOfBasicConstants} is:"
	echo "${listOfBasicConstants}"
}

fxnSetSomeFancyConstants() {

}
# ------------------------- FINISHED: define functions ------------------------- #


# ------------------------- START: define constants ------------------------- #

# Note that the order of these definitions is important when one variable is to
# contain the value of another. For example:
#     nameFirst = Stephen
#     nameFamily = Towler
#     nameFull = "${nameFirst} ${nameFamily}"    # <- this line must follow the lines where $nameFirst and $nameFamily are defined


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 1) anything related to command-line arguments:
#
# e.g. firstArgumentValue="$1"
#


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
# 3) variables specific to the goals of this script:
#    (e.g., variables for file locations, filenames, long arguments, etc.)
# 

# Below are examples and some common variables I like to define, but deactivated for this script by the COMMENTBLOCK lines surrounding them. 
# To use any of these, past them above first COMMENTBLOCK line and edit for your use.
# (Every line between the two COMMENTBLOCK lines is ignored by this script:)
#
: <<'COMMENTBLOCK'
   intensity="t1bfc0"			         # ...to be used in file and folder names
   orientation="radOrig"			      # ...ditto

   # set image directories:

   # ${blindParent}:
   # parent dir where each subject's $blindDir reside (e.g. parent of blind1, blind2, etc.)
   # e.g., blindParent="/home/leonardlab/images/ucr"
   # e.g., allows mkdir ${blindParent}/importedSemiautoLatvens ${blindParent}/blind1

   # ${blindDir}: 
   # dir for each subject's images and image directories:
   # e.g., blindDir="/home/leonardlab/images/ucr/${blind}"
   # e.g., blindDir="${blindParent}/${blind}"

   # ${origDir}: 
   # dir or parent dir where original images will be stored (or are already stored if formatted)
   # e.g., origDir="${blindDir}/acqVolumes"

   # ${anatRoot}}:
   # where the groomed images directory, among others, will live:
   # e.g., anatRoot="${blindDir}/anat-${intensity}-${orientation}"

   # ...source directories for input images:
   # (script should copy images from these [probably poorly organized] source directories
   # to $origDir
   # e.g., sourceT1acqDir="/Users/Shared/cepRedux/acqVolumes"
   # e.g., sourceLatvenDir="/Users/Shared/cepRedux/semiautoLatvens"
   # e.g., sourceBrainDir="/Users/Shared/cepRedux/semiautoExtractedBrains"
   # e.g., sourceFlairDir="/Users/Shared/libon-final/origOrientImageJ" 
   # e.g., sourceWMHImaskDir="/Users/Shared/libon-final/masksOrientImageJ"  

   # ...brainsuite09 paths and definitions:
   #BSTPATH="/data/pricelab/scripts/sdt/brainsuite09/brainsuite09.x86_64-redhat-linux-gnu"
   #BSTPATH="/Users/stowler/Downloads/brainsuite09.i386-apple-darwin9.0"
   #export BSTPATH
   #bstBin="${BSTPATH}/bin/"
   #export bstBin
   #ATLAS="${BSTPATH}/atlas/brainsuite.icbm452.lpi.v08a.img"
   #export ATLAS
   #ATLASLABELS="${BSTPATH}/atlas/brainsuite.icbm452.lpi.v09e3.label.img"
   #export ATLASLABELS
   #ATLASES="--atlas ${ATLAS} --atlaslabels ${ATLASLABELS}"
   #export ATLASES

   # ...FSL variables
   # FSLDIR=""
   # export FSLDIR
   # FSLOUTPUTTYPEorig="${FSLOUTPUTTYPE}"
   # export FSLOUTPUTTYPE=NIFTI_GZ
COMMENTBLOCK

# ------------------------- FINISHED: define constants ------------------------- #


# ------------------------- START: process the invocation ------------------------- #


# always: check for number of arguments, even if expecting zero:
if [ $# -ne 0 ] ; then
   echo ""
   echo "ERROR: this script isn't expecting any arguments."
   echo ""
   fxnPrintUsage
   echo ""
   exit 1
fi


# when needed, process commandline arguments with getopt by removing
# COMMENTBLOCK wrapper and editing:

: <<'COMMENTBLOCK'
# STEP 1/3: initialize any variables that receive values during argument processing:
headingsoff=0
headingsonly=0
# STEP 2/3: set the getopt string:
set -- `getopt rn: "$@"`
# STEP 3/3: process command line switches in  a loop:
[ $# -lt 1 ] && exit 1	# getopt failed
while [ $# -gt 0 ]
do
    case "$1" in
      -r)   headingsoff=1
            ;;
      -n)	headingsonly=1
            ;;
      --)	shift; break
            ;;
      -*)
            echo >&2 "usage: $0 [-r for data row only or -n for column names only] image ..."
             exit 1
             ;;
       *)	break
            ;;		# terminate while loop
    esac
    shift
done
# now all command line switches have been processed, and "$@" contains all file names
# check for incompatible invocation options:
if [ "$headingsoff" != "0" ] && [ "$headingsonly" != "0" ] ; then
   echo ""
   echo "ERROR: cannot specify both -r and -n:"
   echo ""
   fxnPrintUsage
   echo ""
   exit 1
fi
COMMENTBLOCK

# ------------------------- FINISHED: process the invocation ------------------------- #


# ------------------------- START: greet user/logs ------------------------- #

# First get the script name for printing in the banner below:
if [ -z "${scriptName}" ]; do scriptName="`basename ${0}`"; done fi 
# ...then print banner:
echo ""
echo ""
echo "#################################################################"
echo "START: \"${scriptName}\""
      date
echo "#################################################################"
echo ""
echo ""
# ------------------------- FINISHED: greet user/logs------------------------- #


# ------------------------- START: body of script ------------------------- #

# EDITME: by default this template isn't expecting to receive arguments on the
# commandline or automatically write anything to the filesystem. You could just
# paste your list of commands here, save the script, and run it to execute your
# commands in sequence. Past away:

# It helps to have some consistently defined system constants:

# ...or consider staring the script with one of these internal functions:
#
# 	Need a place to put output files? Just uncomment these lines:
# 	fxnSetTempDir                 # <- use internal function to create ${tempDir}
# 	removeTempDirAtEndOfScript=1  # <- set to 1 (==delete) or 0 . See end of script.

# fxnSelftestBasic
# fxnSelftestFull
# fxnValidateImages $@     # verify that all input images are actually images


# For long processes that get called from this script, the user (or log reviwer) might
# like to have some context. Uncomment out this block of banners and place your call
# to someProgramThatJustTakesForever.sh inside of them:
: <<'COMMENTBLOCK'
echo ""
echo ""
echo "================================================================="
echo "START: do some stuff EDITME"
echo "(should take about EDITME minutes)"
      date
echo "================================================================="
echo ""
echo ""

echo "(EDITME) If this line weren't just a placeholder in the template I'd be executing some useful commmands here."

echo ""
echo ""
echo "================================================================="
echo "FINISHED: did some stuff EDITME "
      date
echo "================================================================="
echo ""
echo ""
COMMENTBLOCK


# ------------------------- FINISHED: body of script ------------------------- #


# ------------------------- START: restore environment and say bye to user/logs ------------------------- #

# Output some final status info to the user and clean-up any resources.

# About the temporary directory, if it was defined:
if [ -n ${tempDir} ]; do
	echo ""
	echo ""
	echo "(NB: temporary directory was ${tempDir})"
	echo ""
	echo ""
done
# ...
if [ ${removeTempDirAtEndOfScript} = "1" ]; do

done


	# we care about? If so, let's clean-up:
	# rm -fr ${tempDir} && echo "temporary directory ${tempDir} has been removed.

# Did we change any environmental variables? It would be polite to set them to their original values:
# export FSLOUTPUTTYPE=${FSLOUTPUTTYPEorig}

echo ""
echo ""
echo "#################################################################"
echo "FINISHED: \"${scriptName}\""
      date
echo "#################################################################"
echo ""
echo ""
# ------------------------- FINISHED: restore environment and say bye to user/logs ------------------------- #

