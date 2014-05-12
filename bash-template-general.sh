#!/bin/bash
#
# LOCATION:     <location including filename>
# USAGE:        see internal function below: fxnPrintUsage() 
#
# CREATED:      <date> by stowler@gmail.com
# LAST UPDATED: <date> by stowler@gmail.com
#
# DESCRIPTION:
# <EDITME: description of what the script does>
# 
# SYSTEM REQUIREMENTS:
# - awk must be installed for fxnCalc()
# <EDITME: list or describe other system requirements>
#
# INPUT FILES AND PERMISSIONS FOR OUTPUT:
# <EDITME: list or describe>
#
# OTHER ASSUMPTIONS:
# <EDITME: list or describe>
#
#
# NOTES TO HELP YOU READ AND EDIT THIS SCRIPT:
# 
# This script contains a few first-level sections, each starting with one of these headings:
# ------------------------- START: define functions ------------------------- #
# ------------------------- START: define basic script constants ------------------------- #
# ------------------------- START: greet user/logs ------------------------- #
# ------------------------- START: body of script ------------------------- #
# ------------------------- START: restore environment and say bye to user/logs ------------------------- #
#
# Searchable keywords that mark areas of code:
# EDITME :  areas that should be edited to meet specific needs of system/script/experiment/whatever
# TBD :     areas where I have work to do or decisions to make
# DEBUG :   areas that I only intend to uncomment and execute during debugging
#
# Three has marks ("###") at the beginning of a line mark the line as a comment
# containing training material. This allows the reader to find or skip over
# training material as needed, and allows a shorter version of the script to be
# created by filtering out those training lines.
#
# TBD: implement quiet mode so only summary appears
# TBD: add pretty borders to the summary table
# TBD: usage and self-test if no arguments given
#
### #########!!!!!!! FOR TEMPLATE ONLY. REMOVE THIS BLOCK FROM CHILD SCRIPTS (EDITME): !!!!!!! ###########
### A meta note for editing this template :
###
### LOCATION: 
### https://github.com/stowler/stowlerTemplates/edit/master/bash-template-general.sh
###
### USAGE:
### bash-template-general.sh (no arguments)
### (this executes fxnSelftestBasic if its call is uncommented in script body)
###
### ...but really this is a template from which to build other scripts:
###
### SIMPLE USE:
### (no command-line arguments, no output to filesystem):
### 1) Make a copy of this template script.
### 2) Paste a list of commands into the script body. 
###    (search for "START: body of script". Paste after that.)
### 3) execute the script to run your list of commands
### 4) contemplate the ephemera of the output as it appears in your terminal
###
### INTERMEDIATE USE:
### (no command-line arguments, but output something to ${tempDir} in the filesystem):
### 1) Make a copy of this template script.
### 2) Uncomment the line in the script body that calls fxnSetTempDir. This
###    creates the variable ${tempDir} and then tries to create a new ${tempDir}
###    directory in the filesystem. This will be the temporary directory to which
###    you will send your output files from this script. 
### 3) Paste a list of commands into the script body after calling fxnSetTempDir.
###    This could be pretty much anything, but be sure any output files get
###    routed to ${tempDir}. Like such:
###
###	ls -al ~ > ${tempDir}/aListOfStuffInYourHomeDirectory.txt
###	echo "Um. That's everything as of `date`" >> ${tempDir}/aListOfStuffInMyHomeDirectory.txt
###	cat ${tempDir}/aListOfStuffInMyHomeDirectory.txt
###	echo ""
###	echo "Scroll up to see a listing of the stuff in my home directory"
###	echo "as it was recorded in the recently created text file"
###	echo "called ${tempDir}/aListOfStuffInMyHomeDirectory.txt"
###	echo ""
###
### 4) Execute the script to run your list of commands.
### 5) Enjoy the ephemera appearing in the terminal window while you anticipate
###    what awaits you in ${tempDir} upon script completion. 
### 6) Open a new terminal window and cd to the folder that was created as
###    ${tempDir}. Noticing, of course, that you can't just type "cd ${tempDir}"
###    since the variable ${tempDir} wasn't exported from the script.  Once in
###    ${tempDir} issue "pwd" to confirm your location and then issue "ls" to marvel
###    at the bounty of files you have created.
### 7) Do what you like with your creations in ${tempDir} and then manually delete ${tempDir}.
###
### ADVANCED USE: (TBD)
###
### Design:
### - avoid references to external files  
### - include just enough internal functions so that reasonable child scripts can stand on their own.
###
### Minding pedagogy: 
### - Don't over-functionalize the template. 
###    - banners: they're a good place for a brand-new trainee to make
###      superficial script body edits and see how output is affected
###    - define constants section: trainees will learn to edit variables here in
###      the script body before they work on functions
###    - restoration section: trainees will learn to create functions from this
###      block in the script body
### - Design for brand-new trainees, whose progression is likely:
###    1) run script as intended, inspect typical output
###    2) run script with intentionally bad arguments, and interpret error messages
###    3) read beginning at "START: body of script"
###    4) read beginning at "START: define constants"
###    5) read beginning at "START: define functions"
###    6) edit body of script
###    7) edit existing function definitions
###    8) write new internal functions
###    9) edit invocation
### - make sure edits are reflected in fxnSelftestBasic()
### - test with fxnSelftestBasic() after editing
### 
### ########## !!!!!!! FOR TEMPLATE-ONLY: REMOVE THIS BLOCK FROM CHILD SCRIPTS (EDITME) !!!!!!! ###########



# ------------------------- START: define functions ------------------------- #

### The following are internal functions for this script. They can be  defined in
### any order regardless of interdependencies since each is not interpreted until
### called from the body of the script:


fxnPrintUsage() {
cat <<endOfTextBlock

###############################################################################
#
# ${scriptName} - EDITME: a script to do something. 
#
# EDITME: a slightly longer description of what the script does, probably
# requiring a few lines. Maybe describe the output here. And any return
# codes. This is followed by syntax guidance, in which square brackets ("[]")
# generally indicate optional arguments, angle brackets ("<>") generally
# indicate required arguments, and the pipe symbol ("|") indicates an
# exclusive choice among multiple options.  Example of short syntax guidance
# with all options on one line: 
#
# Usage: ${scriptName} [-r|-n] [-v] <file1> [file2 ...]
#   -r   print data rows only (no column names)
#   -n   pring column names ONLY (no data rows)
#   -v   be verbose
#
###############################################################################

endOfTextBlock
# NB: the terminal "endOfTextBlock" line above must not be indented.
}



fxnPrintDebug() {
  # A function called to print debugging information but only if the debug
  # variable is set to 1.
  
  if [ "${debug}" = "1" ]; then 
     echo "////// DEBUG: ///// $@"
  fi
}



fxnCalc() {
   # fxnCalc is also something I include in my .bash_profile:
   # e.g., calc(){ awk "BEGIN{ print $* }" ;}
   # use quotes if parens are included in the function call:
   # e.g., calc "((3+(2^3)) * 34^2 / 9)-75.89"
   awk "BEGIN{ print $* }" ;
}



fxnSetTempDir() {
   # Attempt to create a temporary directory ${tempDir} .  It will be a child
   # of directory ${tempParent}, which may be set prior to calling this fxn, or
   # will be set to something sensible by this function.
   #
   # NB: ${tempParent} might need to change on a per-system, per-script, or per-experiment basis.
   #    If tempParent or tempDir needs to include identifying information from the script,
   #    just remember to assign values before calling fxnSetTempDir !
   #    e.g., tempParent=${participantDirectory}/manyTempProcessingDirsForThisParticipant && fxnSetTempDir()
   fxnPrintDebug "Starting fxnSetTempDir ..."

   # Is $tempParent already defined as a writable directory? If not, try to define a reasonable one here:
   tempParentPrevouslySetToWritableDir=''
   hostname=`hostname -s`
   kernel=`uname -s`
   fxnPrintDebug "\$tempParent is currently set to ${tempParent}"
   if [ ! -z "${tempParent}" ] && [ -d "${tempParent}" ] && [ -w "${tempParent}" ]; then
      tempParentPreviouslySetToWritableDir=1
      fxnPrintDebug "\$tempParentPreviouslySetToWritableDir=1"
   elif [ $hostname = "stowler-rmbp" ]; then
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
   fxnPrintDebug "\${tempParent} is now ${tempParent}"

   # Now that writable ${tempParent} has been confirmed, create ${tempDir}:
   # e.g., tempDir="${tempParent}/${startDateTime}-tempDirFrom_${scriptName}.${scriptPID}.d"
   tempDir="${tempParent}/${startDateTime}-tempDirFrom_${scriptName}.${scriptPID}.d"
   fxnPrintDebug "\${tempDir} has been set to ${tempDir}"
   # does this $tempDir already exit? if so, don't try to make it again:
   if [ -d "${tempDir}" ] && [ -w "${tempDir}" ]; then
      echo ""
      echo "Can't create this new temporary directory because it already exists as a writable directory:"
      echo "${tempDir}"
      echo ""
   else
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
      else
         echo ""
         echo "A temporary directory has been created:"
         echo "${tempDir}"
         ls -ald "${tempDir}"
         echo ""
      fi
   fi
   fxnPrintDebug "...completed fxnSetTempDir ."
}


fxnProcessInvocation() {
   fxnPrintDebug "Starting fxnProcessInvocation..."

   # If not using getopt to process arguments (see further down), at least
   # check for the correct number of arguments. Or you could do both:
   if [ "${scriptArgsCount}" -ne "0" ] ; then
      echo ""
      echo "ERROR: this script is expecting exactly zero arguments, but it was called with ${scriptArgsCount} arguments."
      echo ""
      fxnPrintUsage
      echo ""
      exit 1
   fi


   # When needed, process commandline arguments with getopt by removing
   # COMMENTBLOCK wrapper and editing:
   
   : <<'COMMENTBLOCK'
   # Process commandline arguments with getopt:
   # (recalling it can't handle arguments with spaces in them)
   #
   # The blocks below may look excessively complex, but the debugging really helps as
   # arguments with spaces and platform incompatibilies need to be dealt with.
   
   
   # STEP 1/3: initialize any variables that receive values during argument processing:
   # (see while loop below for a list of those variables)
   launchSelftest=''
   factorName=''
   levelNameList=''
   levelScript=''
   # ...and if already set, $debug must not lose its current value:
   #if [ -n ${debug} ] ; then debug=${debug} ; else debug=''; fi
   if [ -n ${debug} ] ; then echo "" ; else debug=''; fi
   
   
   # STEP 2/3: set the getopt string:
   
   fxnPrintDebug ""
   fxnPrintDebug "getopt debugging: These are the the variables manipulated while preparing to process arguments:"
   fxnPrintDebug ""
   fxnPrintDebug "getopt debugging:   \$scriptArgsVector : the vector of arguments called at script launch"
   fxnPrintDebug "getopt debugging:   \$scriptArgsCount  : the number of arguments called at script launch"
   fxnPrintDebug "getopt debugging:   \$@ - working vector of arguments"
   fxnPrintDebug 'getopt debugging:   $# - working count of arguments'
   fxnPrintDebug ""
   fxnPrintDebug "getopt debugging: Values before executing 'eval set -- \${scriptArgsVector}' :"
   fxnPrintDebug "getopt debugging: \${scriptArgsVector}=${scriptArgsVector}"
   fxnPrintDebug "getopt debugging: \${scriptArgsCount}=${scriptArgsCount}"
   fxnPrintDebug "getopt debugging: \${@}=${@}"
   fxnPrintDebug "getopt debugging: \${#}=${#}"
   fxnPrintDebug ""
   
   # ...part a of step 2:
   fxnPrintDebug 'getopt debugging: a) assign contents of ${scriptArgsVector} to $@ :'
   eval set -- ${scriptArgsVector}
   fxnPrintDebug "getopt debugging: ...done. Values after executing 'eval set -- \${scriptArgsVector}' :"
   fxnPrintDebug "getopt debugging: \${scriptArgsVector}=${scriptArgsVector}"
   fxnPrintDebug "getopt debugging: \${scriptArgsCount}=${scriptArgsCount}"
   fxnPrintDebug "getopt debugging: \${@}=${@}"
   fxnPrintDebug "getopt debugging: \${#}=${#}"
   fxnPrintDebug ""
   
   
   # ...part b of step 2:
   fxnPrintDebug "getopt debugging: b) use getopt command to parse \$@ and assign result to \$parsedArgs:"
   parsedArgs=`getopt -- tdf:l:s: "$@"`
   if [ $? != 0 ] ; then 
      echo "Terminating...could not set string for getopt. Check out the Usage note:" >&2 
      fxnPrintUsage 
      exit 1 
   fi
   fxnPrintDebug "getopt debugging: ...done. Values after executing 'parsedArgs=\`getopt ... \$@\`' :"
   fxnPrintDebug "getopt debugging: \${scriptArgsVector}=${scriptArgsVector}"
   fxnPrintDebug "getopt debugging: \${scriptArgsCount}=${scriptArgsCount}"
   fxnPrintDebug "getopt debugging: \${@}=${@}"
   fxnPrintDebug "getopt debugging: \${#}=${#}"
   fxnPrintDebug "getopt debugging: \${parsedArgs}=${parsedArgs}"
   fxnPrintDebug ""
   
   
   # ...part c of step 2:
   fxnPrintDebug "getopt debugging: c) generate final arguments (\$1, \$2, etc.) for while loop:"
   eval set -- "${parsedArgs}"
   fxnPrintDebug "getopt debugging: ...done. Values after 'eval set -- \${parsedArgs}\' :"
   fxnPrintDebug "getopt debugging: (i.e., immeditaly prior to while loop)"
   fxnPrintDebug 'getopt debugging: (notice that getopt changes $@ and $#, not $scriptArgsVector or $scriptArgsCount)'
   fxnPrintDebug "getopt debugging: \${scriptArgsVector}=${scriptArgsVector}"
   fxnPrintDebug "getopt debugging: \${scriptArgsCount}=${scriptArgsCount}"
   fxnPrintDebug "getopt debugging: \${@}=${@}"
   fxnPrintDebug "getopt debugging: \${#}=${#}"
   fxnPrintDebug "getopt debugging: \${parsedArgs}=${parsedArgs}"
   fxnPrintDebug ""


   # STEP 3/3: process the command line switches:
   fxnPrintDebug "getopt debugging: executing the while loop to act on the parsed arguments:"
   while true ; do
       fxnPrintDebug "\$1=${1}"
       case "$1" in
         -s)   levelScript="${2}"; shift 2 ;;
         -f)   factorName="${2}" ; shift 2 ;;
         -l)   levelNameList="${2}"; shift 2 ;;
         -t)   launchSelftest="1" ; shift ;;
         -d)   debug="1" ;  shift ;;
         --)   shift; break ;;
         -*)   echo >&2 "usage: $0 -s [levelScript] -f [factorLabel] -l [factorLevelList]" exit 1 ;;
          *)   echo "Error in arguments to ${scriptName}" ; fxnPrintUsage ; exit 1 ;;		# terminate while loop
       esac
   done
   
   # ...and now all command line switches have been processed.
   fxnPrintDebug "getopt debugging: ...done. Values after the getopt while loop :"
   fxnPrintDebug "getopt debugging: \${scriptArgsVector}=${scriptArgsVector}"
   fxnPrintDebug "getopt debugging: \${scriptArgsCount}=${scriptArgsCount}"
   fxnPrintDebug "getopt debugging: \${@}=${@}"
   fxnPrintDebug "getopt debugging: \${#}=${#}"
   fxnPrintDebug "getopt debugging: \${parsedArgs}=${parsedArgs}"
   
   
   # check for incompatible invocation options:
   # if [ "$headingsoff" != "0" ] && [ "$headingsonly" != "0" ] ; then
   #    echo ""
   #    echo "ERROR: cannot specify both -r and -n:"
   #    echo ""
   #    fxnPrintUsage
   #    echo ""
   #    exit 1
   # fi
   
   # if we're showing debug messages, include this final check of invocation
   # variables before returning from fxn:
   fxnPrintDebug ""
   fxnPrintDebug "\${launchSelftest}=${launchSelftest}"
   fxnPrintDebug "\${debug}=${debug}"
   fxnPrintDebug "\${factorName}=${factorName}"
   fxnPrintDebug "\${levelNameList}=${levelNameList}"
   fxnPrintDebug "\${levelScript}=${levelScript}"
   fxnPrintDebug "...completed fxnProcessInvocation ."
   fxnPrintDebug ""
   

COMMENTBLOCK
# ...note that the terminal COMMENTBLOCK line above cannot be indented.

}


fxnSelftestBasic() {
   # Tests the administrative internal functions and variables of the template
   # on which this script is based. This self-test can be used to confirm that
   # the basic functions of the script are working on a particular system, or
   # that they haven't been broken by recent edits. For manual auditing, valid
   # output may appear as comment text at the bottom of this script (TBD). 

   #obviously(?) we want to turn on debugging if we're going to bother with a self-test:
   debug=1
   fxnPrintDebug "Launching internal fxnSelftestBasic ..."

   # First test small functions with no or few dependencies:

   # ...fxnPrintDebug:

   # ...fxnCalc:

   # Now test more complex internal functions in the order in which they are designed to be
   # called from the script body:


   # 1) not really a function, but start by exposing the basic constants defined in this script:
   fxnPrintDebug ""
   fxnPrintDebug "Some basic administrative constants have been defined in this script:"
   fxnPrintDebug ""
   for scriptConstantName in ${listOfBasicConstants}; do
      echo "\$${scriptConstantName} == ${!scriptConstantName}"
   done

   # 2) fxnSetTempDir :
   fxnPrintDebug ""
   fxnPrintDebug "Creating temporary directory by calling this script's internal function 'fxnSetTempDir' :"
   fxnSetTempDir
   deleteTempDirAtEndOfScript=0
   if [ ! -z  "${tempDir}" ] && [ -d "${tempDir}" ] && [ -w "${tempDir}" ]; then
	fxnPrintDebug "...success: confirmed that you have file sysem write permissions for \${tempDir}:"
	ls -aldh ${tempDir}
	fxnPrintDebug "...with its final destiny set by \${deleteTempDirAtEndOfScript} == ${deleteTempDirAtEndOfScript}"
	fxnPrintDebug ""
   else
	echo "WARNING: was not able to create a writable temporary directory."
	exit 1
   fi

   # 3) fxnPrintUsage :
   fxnPrintDebug ""
   fxnPrintDebug "Below is the usage note the user should see if asking for help or incorrectly calling this script:"
   fxnPrintDebug "(produced by script's internal function 'fxnPrintUsage')"
   fxnPrintDebug ""
   fxnPrintUsage

   # Strip out all comments that are marked as training. This will create a
   # slimmer, more readable version of the script :
   trainingMarker='###'       # trainingMarker must be sed-friendly. See below:
   fxnPrintDebug "Removing training comments from the current script (lines prepended with '${trainingMarker}' ...)"
   cp ${scriptPath}/${scriptName} ${tempDir}/script-orig.sh
   sed "/^${trainingMarker}/ d" ${tempDir}/script-orig.sh > ${tempDir}/script-withoutTrainingComments.sh
   linecountOrig="`wc -l ${tempDir}/script-orig.sh | awk '{print $1}'`"
   linecountSkinny="`wc -l ${tempDir}/script-withoutTrainingComments.sh | awk '{print $1}'`"
   fxnPrintDebug "...done removing training comments."
   fxnPrintDebug "The current script (${scriptName}) has ${linecountOrig} lines, and I have generated a version"
   fxnPrintDebug "without training comments that has ${linecountSkinny} lines:"
   ls -l ${tempDir}/*
   fxnPrintDebug "Completed internal function fxnSelftestBasic ."
}


fxnSelftestFull() {
  # Tests the full function of the script. Begins by calling fxnSelftestBaic() , and then...
  # <EDITME: add description of tests and validating data>
  fxnSelftestBasic
}



fxnSetSomeFancyConstants() {
### Note that the order of these definitions is important when one variable is to
### contain the value of another. For example:
###     nameFirst = Stephen
###     nameFamily = Towler
###     nameFull = "${nameFirst} ${nameFamily}"    # <- this line must follow the lines where $nameFirst and $nameFamily are defined


### Below are examples and some common variables I like to define, but
### deactivated for this script by the COMMENTBLOCK lines surrounding them.
### To use any of these, past them above first COMMENTBLOCK line and edit for
### your use.  (Every line between the two COMMENTBLOCK lines is ignored by
### this script:)
### TBD: I haven't looked at thse in a thousand years but should be fine for illustration:
###
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
### constants because their values don't change during script execution.

# NB: these are per-script constants, so it's safer to define them here rather
# than in an internal function.

listOfBasicConstants=''

scriptName="`basename $0`"
listOfBasicConstants="${listOfBasicConstants} scriptName"

# getting scriptPath is non-trivial, and this is adapted from
# http://stackoverflow.com/a/12197518 :
pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
while([ -h "${SCRIPT_PATH}" ]); do
    cd "`dirname "${SCRIPT_PATH}"`"
    SCRIPT_PATH="$(readlink "`basename "${SCRIPT_PATH}"`")";
done
cd "`dirname "${SCRIPT_PATH}"`" > /dev/null
scriptPath="`pwd`";
popd  > /dev/null
listOfBasicConstants="${listOfBasicConstants} scriptPath"
# less robust 1-line solution:
# scriptPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

scriptPWD="`pwd`"
listOfBasicConstants="${listOfBasicConstants} scriptPWD"

scriptHostname="`hostname`"
listOfBasicConstants="${listOfBasicConstants} scriptHostname"

scriptUnameOS="`uname -s`"
listOfBasicConstants="${listOfBasicConstants} scriptUnameOS"

scriptUnameLong="`uname -a`"
listOfBasicConstants="${listOfBasicConstants} scriptUnameLong"

scriptPID="$$"
listOfBasicConstants="${listOfBasicConstants} scriptPID"

scriptArgsVector="${@}"
listOfBasicConstants="${listOfBasicConstants} scriptArgsCount"

scriptArgsCount=$#
listOfBasicConstants="${listOfBasicConstants} scriptArgsCount"

scriptUser="`whoami`"
listOfBasicConstants="${listOfBasicConstants} scriptUser"

startDate="`date +%Y%m%d`"
listOfBasicConstants="${listOfBasicConstants} startDate"

startDateTime="`date +%Y%m%d%H%M%S`"
listOfBasicConstants="${listOfBasicConstants} startDateTime"

deleteTempDirAtEndOfScript=0
listOfBasicConstants="${listOfBasicConstants} deleteTempDirAtEndOfScript"

# echo "DEBUG: \${listOfBasicConstants} is:"
# echo "${listOfBasicConstants}"



# ------------------------- FINISH: define basic script constants ------------------------- #


# ------------------------- START: greet user/logs ------------------------- #

clear

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

### To keep things simple, you could just paste a list of commands in the blank
### space immediately below this comment block, save the script under a new name,
### and run it.  This would work because by default this template script isn't
### expecting to receive arguments on the commandline or automatically write
### anything to the filesystem (though it does have those powers...see below).
### Paste commands here if that's all you need right now:



### ...or, to be fancier, you could first call one or more of the internal
### functions defined in this script template. They are designed to make your
### script-writing easier, and you can inspect their code right here in
### this file. Consider starting your script by calling one or more of these internal
### functions, followed by the lines that do the real work of your script.
### 
### For example, you could uncomment any of these four internal function calls
### and then paste your material lines in the space after the calls :
###
### 1) If this script needs to generate output files, it might be nice to create
###    an informatively-named temporary directory on disk and save its location
###    to variable ${tempDir}, which you can then call throught this script.
###    To do so just uncomment these two lines:

# Setup a temporary directory, which can be configured for clean-up:
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
fxnSelftestBasic
#...the script will exit after completing the self-test, ignoring all lines below.



### After calling internal script functions above, paste the lines for completing
### the script's real work below this comment block.
###
### For long processes that get called from this script, the user (or log reviwer) might
### like to have some context. Uncomment out this block of banners and place your call
### to someProgramThatJustTakesForever.sh inside of them:
###
: <<'COMMENTBLOCK'
echo ""
echo ""
echo "================================================================="
echo "START: do some stuff (EDITME: add real one-line description)"
echo "(should take about EDITME minutes)"
      date
echo "================================================================="
echo ""
echo ""

echo "(EDITME) If this line weren't just a placeholder in the template I'd be executing some useful commmands here."

echo ""
echo ""
echo "================================================================="
echo "FINISHED: did some stuff  (EDITME: add real one-line description)"
      date
echo "================================================================="
echo ""
echo ""
COMMENTBLOCK


#TBD: call fxnSelftestBasic if nothing happened earlier in the script

# ------------------------- FINISHED: body of script ------------------------- #


# ------------------------- START: restore environment and say bye to user/logs ------------------------- #
#
# Output some final status info to the user/log and clean-up any resources.

# If a ${tempDir} was defined, remind the user about it and (optionally) delete it:
if [ -n "${tempDir}" ]; then 
	#tempDirSize=`du -sh ${tempDir} | cut -d ' ' -f 1`
	tempDirSize=`du -sh ${tempDir} | cut -f 1`
	tempDirFileCount=`find ${tempDir} | wc -l`
	echo ""
	echo ""
	echo "Script complete. This script's temporary directory is:"
	ls -ld ${tempDir}
	echo "...and it contains: ${tempDirFileCount} files and folders taking up total disk space of ${tempDirSize}"
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

