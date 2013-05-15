#!/bin/bash
#
# LOCATION:	      <location including filename>
# USAGE:	         see the fxnPrintUsage() function below 
#
# CREATED:	      <date> by stowler@gmail.com
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
#
# READING AND CODING NOTES:
# 
# This script contains a few first-level sections, each starting with one of these headings:
# ------------------------- START: define functions ------------------------- #
# ------------------------- START: define basic script constants ------------------------- #
# ------------------------- START: greet user/logs ------------------------- #
# ------------------------- START: body of script ------------------------- #
# ------------------------- START: restore environment and say bye to user/logs ------------------------- #
#
# Search for "EDITME" to find areas that may need to be edited on a
# per-system/per-experiment/per-whatever basis.
#
# Search for "TBD" to find areas where I have work to do, decisions to make, etc. TBD.
#
# Search for "DEBUG" to find areas that I only intend to execute duing debugging.
#
# Lines starting with "###" (three hash marks) are marked as training material
# so they can be stripped out automatically
#
#
# #########!!!!!!! EDITME FOR TEMPLATE ONLY. REMOVE FROM CHILD SCRIPTS: !!!!!!! ###########
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
# SIMPLE USE:
# (no command-line arguments, no output to filesystem):
# 1) Make a copy of this template script.
# 2) Paste a list of commands into the script body. 
#    (search for "START: body of script". Paste after that.)
# 3) execute the script to run your list of commands
# 4) contemplate the ephemera of the output as it appears in your terminal
#
# INTERMEDIATE USE:
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
# TBD: ADVANCED USE:
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
# ########## !!!!!!! EDITME FOR TEMPLATE-ONLY: REMOVE FROM CHILD SCRIPTS !!!!!!! ###########



# ------------------------- START: define functions ------------------------- #

# The following are internal functions for this script. They can be  defined in
# any order regardless of interdependencies since each is not interpreted until
# called from the body of the script:


fxnPrintUsage() {
   # EDITME: customize for each script:
   echo >&2 "$0 - a script to do something. Example of a usage note:"
   echo >&2 "Usage: scriptname [-r|-n] -v file {file2 ...}"
   echo >&2 "  -r   print data rows only (no column names)"
   echo >&2 "  -n   pring column names ONLY (no data rows)"
   echo >&2 "  -v   be verbose"
}


fxnProcessInvocation() {

# always: check for number of arguments, even if expecting zero:
if [ "${scriptArgsCount}" -ne "0" ] ; then
   echo ""
   echo "ERROR: this script isn't expecting any arguments. You provided $scriptArgsCount ."
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
}


fxnSelftestBasic() {
   # Tests the basic funcions and variables of the template on which this
   # script is based. Valid output may appear as comment text at the bottom
   # of this script (TBD). This can be used to confirm that the basic functions
   # of the script are working on a particular system, or that they haven't
   # been broken by recent edits.

   echo "Running internal function fxnSelftestBasic :"
   echo ""

   # expose the basic constants defined in the script:
   echo "Some basic constants have been defined in this script."
   echo "Their names are listed in variable \${listOfBasicConstants} : "
   echo "${listOfBasicConstants}"
   echo ""
   #echo "...and here are their values:"
   #for scriptConstantName in ${listOfBasicConstants}; do
   #   scriptConstantValue="`echo ${scriptConstantName}`"
   #   echo "${scriptConstantName} == ${scriptConstantValue}"
   #done

   # test internal function fxnSetTempDir:
   fxnSetTempDir
   deleteTempDirAtEndOfScript=1

   # Strip out all comments that are marked as teaching. This will create a
   # slimmer, more readable version of the script :
   trainingMarker='###'       # trainingMarker must be sed-friendly. See below:
   cp ${scriptDir}/${scriptName} ${tempDir}/script-orig.sh
   sed "/^${trainingMarker}/ d" ${tempDir}/script-orig.sh > ${tempDir}/script-withoutTrainingComments.sh
   linecountOrig="`wc -l ${tempDir}/script-orig.sh | awk '{print $1}'`"
   linecountSkinny="`wc -l ${tempDir}/script-withoutTrainingComments.sh | awk '{print $1}'`"
   echo ""
   echo "This script has ${linecountOrig} lines, and the version without training comments has ${linecountSkinny} lines:"
   echo ""
   ls -l ${tempDir}/*
}


fxnSelftestFull() {
  # Tests the full function of the script. Begins by calling fxnSelftestBaic() , and then...
  # <EDITME: description of tests and validating data>
  fxnSelftestBasic
}


fxnCalc() {
   # fxnCalc is also something I include in my .bash_profile:
   # e.g., calc(){ awk "BEGIN{ print $* }" ;}
   # use quotes if parens are included in the function call:
   # e.g., calc "((3+(2^3)) * 34^2 / 9)-75.89"
   awk "BEGIN{ print $* }" ;
}


fxnSetTempDir() {
   # Attempt to create a temporary directory ${tempDir} .
   # This will be a child of directory ${tempParent}, which maybe set prior to calling this fxn, 
   # or will be set to something sensible by this function.
   #
   # NB: ${tempParent} might need to change on a per-system, per-script, or per-experiment, basis
   #    If tempParent or tempDir needs to include identifying information from the script,
   #    remember to assign values before calling fxnSetTempDir!)
   #    e.g., tempParent=${participantDirectory}/manyTempProcessingDirsForThisParticipant && fxnSetTempDir()

   # Is $tempParent already defined as a writable directory? If not, try to define a reasonable one:
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
      echo "fxnSetTempDir cannot find a suitable parent directory in which to \
	    create a new temporary directory. Edit script's $tempParent variable. Exiting."
      exit 1
   fi
   # echo "DEBUG"
   # echo "DEBUG: \${tempParent} is ${tempParent}"
   # echo "DEBUG:"

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


fxnSetSomeFancyConstants() {
	# Note that the order of these definitions is important when one variable is to
	# contain the value of another. For example:
	#     nameFirst = Stephen
	#     nameFamily = Towler
	#     nameFull = "${nameFirst} ${nameFamily}"    # <- this line must follow the lines where $nameFirst and $nameFamily are defined


   # Below are examples and some common variables I like to define, but
   # deactivated for this script by the COMMENTBLOCK lines surrounding them.
   # To use any of these, past them above first COMMENTBLOCK line and edit for
   # your use.  (Every line between the two COMMENTBLOCK lines is ignored by
   # this script:)
   # TBD: I haven't looked at thse in a thousand years but should be fine for illustration:
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
}

# ------------------------- FINISHED: define functions ------------------------- #


# ------------------------- START: define basic script constants ------------------------- #

### Create some constants to make basic system information convenient for
### the script. These are technically variables but we are calling them
### constants because their values don't change during the script.
###

listOfBasicConstants=''	

scriptName="`basename $0`"
listOfBasicConstants="\$scriptName ${listOfBasicConstants}"

scriptDir="`dirname $0`"
listOfBasicConstants="\$scriptDir ${listOfBasicConstants}"

scriptPID="$$"
listOfBasicConstants="\$scriptPID ${listOfBasicConstants}"

scriptArgsCount=$#
listOfBasicConstants="\$scriptArgsCount ${listOfBasicConstants}"

scriptUser="`whoami`"
listOfBasicConstants="\$scriptUser ${listOfBasicConstants}"

startDate="`date +%Y%m%d`"
listOfBasicConstants="\$startDate ${listOfBasicConstants}"

startDateTime="`date +%Y%m%d%H%M%S`"
listOfBasicConstants="\$startDateTime ${listOfBasicConstants}"

# echo "DEBUG: \${listOfBasicConstants} is:"
# echo "${listOfBasicConstants}"

# NB: these are per-script constants, and therefore must be defined here, rather than in a function:

# ------------------------- FINISH: define basic script constants ------------------------- #


# ------------------------- START: greet user/logs ------------------------- #

# First get the script name for printing in the banner below:
if [ -z "${scriptName}" ]; then scriptName="`basename ${0}`" ; fi 
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

### To keep things simple, you could just paste a list of commands on the lines
### immediately below this comment, save the script under a new name, and run it.
### This would work because by default this template script isn't expecting to
### receive arguments on the commandline or automatically write anything to the
### filesystem (though it does have those powers...see below). 
### Paste commands here if that's all you need right now:



### ...or, to be fancier, you could first call one or more of the internal
### functions defined in this script. These are designed to make your
### script-writing easier, and you can inspect their code right here in
### this file. Consider starting your script with one or more of these internal
### functions. Then the lines that do the real work of your script should appear
### after these internal function calls:

### 1) If this script needs to generate output files, it might be nice to create
###    an informatively-named temporary directory ${tempDir} as their destination.
###    To do so just uncomment these two lines:
###
#fxnSetTempDir                 # <- use internal function to create ${tempDir}
#deleteTempDirAtEndOfScript=1  # <- set to 1 to delete ${tempDir} or 0 to leave it. See end of script.


### 2) Does this script need to accept arguments on the commandline? If so, it
###    would be nice to check the validity of those arguments, and assign them
###    to variables in this script.
###    To do so just uncomment this line, which will call one of this template
###    script's internal functions:
###
#fxnProcessInvocation          
# ...and then edit its function definition for your specific needs.


### 3) It's convenient to declare some constants that contain information
###    specific for a script's goals (file paths and names, lists of participants,
###    etc.)
###    To do so just uncomment this line, which will call one of this template
###    script's internal functions:
###
#fxnSetSomeFancyConstants
# ...and then edit its function definition for your specific needs.


### 4) It's good to confirm that a script is working correctly after editing it
###    or transfering to a new machine.
###    To do so just uncomment this line, which will call one of this template
###    script's internal functions:
###
#fxnSelftestBasic
#...the script will exit after completing the self-test, ignoring all lines below.




### For long processes that get called from this script, the user (or log reviwer) might
### like to have some context. Uncomment out this block of banners and place your call
### to someProgramThatJustTakesForever.sh inside of them:
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
#
# Output some final status info to the user/log and clean-up any resources.

# If a ${tempDir} was defined, remind the user about it and (optionally) delete it:
if [ -n "${tempDir}" ]; then 
	tempDirSize=`du -sh | cut -d ' ' -f 1`
	tempDirFileCount=`find ${tempDir} | wc -l`
	echo ""
	echo ""
	echo "NB: temporary directory is ${tempDir}"
	echo "...and it contains: ${tempDirFileCount} files and folders taking up total disk space of ${tempDirSize}"
	ls -ld ${tempDir}
	echo ""
	# if previously indicated, delete $tempDir
	if [ ${deleteTempDirAtEndOfScript} = "1" ]; then
		echo -n "...which I am now removing..."
		rm -fr ${tempDir}
		echo "done." 
      echo "Proof of removal per \"ls -ld \${tempDir}\" :"
		ls -ld ${tempDir}
	fi
	echo ""
	echo ""
fi

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

