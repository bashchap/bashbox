#!/bin/bash

# Paths
dirBin=$(dirname $0)
dirHome=${dirBin}/..
dirCfg=${dirHome}/cfg
dirCfgSystem=${dirHome}/cfg/system
dirCfgSystemState=${dirHome}/cfg/system/state
dirLogs=${dirHome}/logs
logFile=${dirLogs}/processLog

# Character mapping
source ${dirCfg}/characterMap.cfg
source ${dirCfg}/transformationMap.cfg

pLog() {
 echo -e "$*" >>${logFile} 
}

# This is a temporary routine
# Provide: X Y coordinates
printChar() {
# This sequence represents tput cup y x - esc[y+1;x+1H
 echo -en "\033[$(($2+1));$(($1+1))H$3"
}

#####################################################
#############################
##
#	START HERE

clear

declare -i xOff=12 yOff=6
declare -i x=0 y=0
declare -i xPos=0 yPos=0
declare -i xSpacer=6

  for ((y=0; y<16; y++))
  do
    yPos=$((yOff+y))

# Output Column names
    uCSC="u${bitMap[$y]#bm}"
    xPos=$((xOff-3))
    printChar $((xPos)) $((yPos)) "${y}"
    printChar $((xPos-2)) $((yPos)) "\u${!uCSC}"
    printChar $((xPos-7)) $((yPos)) "${uCSC#u}"

      for ((x=0; x<16; x++))
      do

# Output Row names
          if [ ${y} -eq 0 ]
          then
            xPos=$((xOff+(x*$xSpacer)))
            uCSC="u${bitMap[$x]#bm}"
            printChar $xPos $((yPos-5)) "${uCSC#u}"
            printChar $xPos $((yPos-4)) "${!uCSC}"
            printChar $xPos $((yPos-3)) "\u${!uCSC}"
            printChar $xPos $((yPos-2)) "${x}"
          fi

# Output x OR'd with Y chars
        xPos=$((xOff+(x*$xSpacer)))
        uCSC="u${bitMap[$((${x}|${y}))]#bm}"
        printChar $xPos $yPos "\u${!uCSC}" 

      done
  done
echo
echo
echo

