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
# This script contains a few first-level sections, each starting with one of these headings:
# ------------------------- START: define functions ------------------------- #
# ------------------------- START: define constants ------------------------- #
# ------------------------- START: process the invocation ------------------------- #
# ------------------------- START: greet user/logs ------------------------- #
# ------------------------- START: body of program ------------------------- #
# ------------------------- START: restore environment and say bye to user/logs ------------------------- #



# ------------------------- START: define functions ------------------------- #

fxnPrintUsage() {
   #EDITME: customize for each script:
   echo >&2 "$0 - a script to do something"
   echo >&2 "Usage: scriptname [-r|-n] -v file {file2 ...}"
   echo >&2 "  -r   print data rows only (no column names)"
   echo >&2 "  -n   pring column names ONLY (no data rows)"
   echo >&2 "  -v   be verbose"
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


fxnValidateInputImages() {
   invalidInputList=""
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
# 3) app-specific shenanigans:
#
# e.g., variables for file locations, filenames, long arguments, etc.
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


# ------------------------- START: body of program ------------------------- #

# fxnSetTempDir                 # setup and create $tempDir if necessary
# fxnValidateInputImages $@     # verify that all input images are actually images
# TBD: Verify that destination directories exist and are user-writable:

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

# ------------------------- FINISHED: body of program ------------------------- #


# ------------------------- START: restore environment and say bye to user/logs ------------------------- #

# rm -fr ${tempDir}
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

