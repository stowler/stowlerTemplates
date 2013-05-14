#!/bin/bash
#
# LOCATION:	<location including filename>
# USAGE:	see fxnPrintUsage() function below 
#
# CREATED:        <date> by stowler@gmail.com
# LAST UPDATED:	<date> by stowler@gmail.com
#
# DESCRIPTION:
# <description of what the script does>
# 
# SYSTEM REQUIREMENTS:
#  - awk must be installed for fxnCalc
#   <list or describe others>
#
# INPUT FILES AND PERMISSIONS FOR OUTPUT:
# <list or describe>
#
# OTHER ASSUMPTIONS:
# <list or describe>
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
# Search for "EDITME" to find areas that may need to be edited on a per-system/per-experiment/per-whatever basis.
# Search for "TBD" to find areas where I have work to do, decisions to make, etc. TBD.
#
########### !!!!!!! FOR TEMPLATE ONLY. REMOVE FROM CHILD SCRIPTS: !!!!!!! ###########
# A meta note for editing this template :
#
# Location: 
# https://github.com/stowler/stowlerTemplates/edit/master/bash-template-general.sh
#
# Design:
# - avoid references to external files  
# - include just enough internal functions so that reasonable child scripts can stand on their own.
#
# Minding pedagogy: 
# - Don't over-functionalize the template. It provides babysteps for trainees who don't yet understand internal functions:
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
########### !!!!!!! FORTEMPLATE-ONLY: REMOVE FROM CHILD SCRIPTS !!!!!!! ###########



# ------------------------- START: define functions ------------------------- #

# internal functions, defined in any order regarless of interdependencies since they're not interpreted until called from the body of the script:

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


fxnCalc() {
   # fxnCalc is also something I include in my .bash_profile:
   # e.g., calc(){ awk "BEGIN{ print $* }" ;}
   # use quotes if parens are included in the function call:
   # e.g., calc "((3+(2^3)) * 34^2 / 9)-75.89"
   awk "BEGIN{ print $* }" ;
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

# ------------------------- FINISHED: define functions ------------------------- #


# ------------------------- START: define constants ------------------------- #

# Note that the order of these definitions is important when one variable is to contain the value of another, e.g., 
#     nameFirst = Stephen
#     nameFamily = Towler
#     nameFull = "${nameFirst} ${nameFamily}"    # this line must follow the lines where $nameFirst and $nameFamily are defined


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 1) anything related to command-line arguments:
#
# e.g. firstArgumentValue="$1"
#


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
# 2)  basic system resources:
#

scriptName=`basename $0`		# ...assign a constant here if not calling from a script
scriptPID="$$"				# ...assign a constant here if not calling from a script
#scriptDir=""				# ...used to get to other scripts in same directory
scriptUser=`whoami`			# ...used in file and dir names
startDate=`date +%Y%m%d`		# ...used in file and dir names
startDateTime=`date +%Y%m%d%H%M%S`	# ...used in file and dir names
#cdMountPoint


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
if [ $# -lt 1 ] ; then
   echo ""
   echo "ERROR: no files specified"
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

# consider staring the script with one of these internal functions:
# fxnSelftestBasic
# fxnSelftestFull
# fxnSetTempDir                 # setup and create $tempDir if necessary
# fxnValidateImages $@     # verify that all input images are actually images

echo ""
echo ""
echo "================================================================="
echo "START: do some stuff"
echo "(should take about TBD minutes)"
      date
echo "================================================================="
echo ""
echo ""

# stuff stuff stuff

echo ""
echo ""
echo "================================================================="
echo "FINISHED: did some stuff "
      date
echo "================================================================="
echo ""
echo ""



echo ""
echo ""
echo "================================================================="
echo "START: do some other stuff"
echo "(should take about TBD minutes)"
      date
echo "================================================================="
echo ""
echo ""

# other stuff stuff stuff

echo ""
echo ""
echo "================================================================="
echo "FINISHED: did some other stuff "
      date
echo "================================================================="
echo ""
echo ""

# ------------------------- FINISHED: body of script ------------------------- #


# ------------------------- START: restore environment and say bye to user/logs ------------------------- #

# Did we create a temporary directory that we don't need to keep, either because the contents are garbag or because we already copied out the contents we care about?
# rm -fr ${tempDir}

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

