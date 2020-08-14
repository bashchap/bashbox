#!/bin/bash
# Written by Tara Ram 9th August 2020 during lockdown in Mayanmar :)

# Purpose is simply to draw boxes but with a little extra something going on.
# Additional logic enables existing characters to merge with new ones to create
# seemless intersections, i.e. no broken boxes.

clear

trap cleanupDuties EXIT

# Paths
dirBin=$(dirname $0)
dirHome=${dirBin}/..
dirCfg=${dirHome}/cfg
dirCfgSystem=${dirHome}/cfg/system
dirCfgSystemState=${dirHome}/cfg/system/state
dirLogs=${dirHome}/logs
logFile=${dirLogs}/processLog
logicPlainStateFile=${dirCfgSystemState}/logicPlain.state
displayPlainStateFile=${dirCfgSystemState}/displayPlain.state
artifactRegisterStateFile=${dirCfgSystemState}/artifactRegister.state
artifactRenderStateFile=${dirCfgSystemState}/artifactRender.state
artifactKeysStateFile=${dirCfgSystemState}/artifactKeys.state

# Character mapping
source ${dirCfg}/characterMap.cfg
source ${dirCfg}/transformationMap.cfg

pLog() {
 echo -e "$*" >>${logFile} 
}

makeChar() {
 artifactName=$1 charShortCode=$2 dcx=$3 dcy=$4
 xyKey="$dcx,$dcy"
# Override provided CSC if coordinates will create a straigh line
   [ ${h} -eq 1 -a ${w} -gt 1 ] && charShortCode=HCL
   [ ${w} -eq 1 -a ${h} -gt 1 ] && charShortCode=VCL
# Setup xref variable bitmap code of CSC
 bitMapCode=bm${charShortCode} 
 logicPlain[${xyKey}]=$((${logicPlain[${xyKey}]:-0}|${!bitMapCode}))
 xyKeyChar="u${bitMap[${logicPlain[${xyKey}]}]#bm}"
 displayPlain[${xyKey}]="\u${!xyKeyChar}"
 displayChar="${displayPlain[${xyKey}]:-" "}"
# At this stage have generated the morphed character
 addArtifactKeys ${artifactName} ${xyKey}
}

# Provide: $1=Artifact name, $2=Artifact Key
addArtifactKeys() {
 artifactKeys[${1}]="${artifactKeys[$1]} $2 " 
# pLog "$1 = ${artifactKeys[$1]}"
}

# Provide: $1=Artifact Name
displayArtifact() {
 thisArtifact=""
   if [ "${artifactRender["$1"]}" = "" ]
   then
#     pLog "displayArtifact() - Creating $1"
       for xyKey in ${artifactKeys[$1]} 
       do
         x=${xyKey%,*} y=${xyKey#*,}     
         thisArtifact="${thisArtifact}\033[$(($y+1));$(($x+1))H${displayPlain[${xyKey}]:-" "}"
       done
     artifactRender["${1}"]="${thisArtifact}"
   else
#     pLog "displayArtifact() - $1 already exists"
     thisArtifact="${artifactRender["${1}"]}"
   fi
 echo -ne "${thisArtifact}"
}

# This is a temporary routine
# Provide: X Y coordinates
printChar() {
# This sequence represents tput cup y x - esc[y+1;x+1H
 echo -en "\033[$(($2+1));$(($1+1))H$3"
}

# Provide: Artifact Name, x y, w, h
registerArtifact() {
# need to check for existing artifact name - they should all be unique
 artifactRegister[$1]="$2,$3,$4,$5"
# pLog $1 $2 $3 $4 $5
}

# Provide: Name X Y W H
createArtifact() {
 artifactName=$1
# If an artifact already exists with that name so need to do anything else
   if [ "${artifactRegister[${artifactName}]}" != "" ]
   then
#     pLog "createArtifact() - $artifactName already exists"
     return
   fi

 registerArtifact $1 $2 $3 $4 $5
 declare -i x=$2 y=$3 w=$4 h=$5
 declare -i xAw=x+w-1
 declare -i yAh=y+h-1
# Work out corner coordinates
 declare -i xTLC=x yTLC=y
 declare -i xTRC=xAw yTRC=y
 declare -i xBLC=x yBLC=yAh
 declare -i xBRC=xAw yBRC=yAh

# Draw corners
 makeChar ${artifactName} TLC $xTLC $yTLC
 makeChar ${artifactName} TRC $xTRC $yTRC
 makeChar ${artifactName} BLC $xBLC $yBLC
 makeChar ${artifactName} BRC $xBRC $yBRC

# Draw Top and bottom horizontal lines
 declare -i cX=x
 declare -i cY=y
 cX=xTLC+1
   while [ ${cX} -le $((xTRC-1)) ]
   do
     makeChar ${artifactName} HCL $cX $yTLC
     makeChar ${artifactName} HCL $cX $yBLC
     cX+=1 
   done
# Draw Left and right vertical lines
 cY=yTLC+1
   while [ ${cY} -le $((yBLC-1)) ]
   do
     makeChar ${artifactName} VCL $xTLC $cY
     makeChar ${artifactName} VCL $xTRC $cY
     cY+=1 
   done
}

dumpLogicPlain() {
{
  echo -ne "#!/bin/bash

declare -A logicPlain=("
    for allKeys in ${!logicPlain[*]}
    do
      echo -ne "[${allKeys}]=\"${logicPlain[${allKeys}]}\" "
    done
  echo ")"
} >${logicPlainStateFile}
}

dumpDisplayPlain() {
{
  echo -ne "#!/bin/bash

declare -A displayPlain=("
    for allKeys in ${!displayPlain[*]}
    do
      echo -ne "[${allKeys}]=\"${displayPlain[${allKeys}]}\" "
    done
  echo ")"
} >${displayPlainStateFile}
}

dumpArtifactRegister() {
{
  echo -ne "#!/bin/bash

declare -A artifactRegister=("
    for allKeys in ${!artifactRegister[*]}
    do
      echo -ne "[${allKeys}]=\"${artifactRegister[${allKeys}]}\" "
    done
  echo ")"
} >${artifactRegisterStateFile}
}

dumpArtifactRender() {
{
  echo -ne "#!/bin/bash

declare -A artifactRender=("
    for allKeys in ${!artifactRender[*]}
    do
      echo -ne "[${allKeys}]=\"${artifactRender[${allKeys}]}\" "
    done
  echo ")"
} >${artifactRenderStateFile}
}

dumpArtifactKeys() {
{
  echo -ne "#!/bin/bash

declare -A artifactKeys=("
    for allKeys in ${!artifactKeys[*]}
    do
      echo -ne "[${allKeys}]=\"${artifactKeys[${allKeys}]}\" "
    done
  echo ")"
} >${artifactKeysStateFile}
}

cleanupDuties() {
 pLog "> Exit signal detected - performing $0 cleanup and recovery:"
 dumpLogicPlain
 dumpDisplayPlain
 dumpArtifactRegister
 dumpArtifactKeys
 dumpArtifactRender
}

#####################################################
#############################
##
#	START HERE

declare -A logicPlain displayPlain artifactRegister artifactKeys artifactRender

# Recover system state from cache
   [ -f ${logicPlainStateFile} ]	&& source ${logicPlainStateFile}
   [ -f ${displayPlainStateFile} ] 	&& source ${displayPlainStateFile}
   [ -f ${artifactRegisterStateFile} ]	&& source ${artifactRegisterStateFile}
   [ -f ${artifactKeysStateFile} ]	&& source ${artifactKeysStateFile}
   [ -f ${artifactRenderStateFile} ]	&& source ${artifactRenderStateFile}


# Test code to just show how the code works.
# All you really need to do is issue the createArtifact line below with x y width and height values.
# Top left corner of the screen screen is 0,0.  Minimum value for w and h is 1 - same square.
declare -i aCount=1
declare -i maxCols=$(tput cols) count=0
declare -i maxRows=$(tput lines)
  while :
  do count+=1
      if [ $((${count}%1000)) -eq 0 ]
      then
        unset logicPlain displayPlain artifactRegister artifactKeys artifactRender
        declare -A logicPlain displayPlain artifactRegister artifactKeys artifactRender
        clear
      fi

    x=$((RANDOM%(maxCols-8)))
    y=$((RANDOM%(maxRows-8)))
    w=$(($((RANDOM%(maxCols-x)+1))%20+1))
#    w=$(($((RANDOM%(maxCols-x)+1))+1))
    h=$(($((RANDOM%(maxRows-y-1)+1))%20+1))
#    h=$(($((RANDOM%(maxRows-y-1)+1))+1))
    createArtifact artifact_${aCount} $x $y $w $h
    displayArtifact artifact_${aCount}
    aCount+=1

  done

exit

createArtifact Outline 0 0 $maxCols $maxRows
createArtifact Menu 1 1 15 13
createArtifact Status 0 $((maxRows-3)) $maxCols 3

displayArtifact Outline
displayArtifact Status
displayArtifact Menu

