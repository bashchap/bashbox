#!/bin/bash
# Written by Tara Ram 9th August 2020 during lockdown in Mayanmar :)

# Purpose is simply to draw boxes but with a little extra something going on.
# Additional logic enables existing characters to merge with new ones to create
# seemless intersections, i.e. no broken boxes.
clear


# Paths
dirBin=$(dirname $0)
dirHome=${dirBin}/..
dirCfg=${dirHome}/cfg
dirLogs=${dirHome}/logs
logFile=${dirLogs}/processLog

# Character mapping
source ${dirCfg}/characterMap.cfg
source ${dirCfg}/transformationMap.cfg

pLog() {
 echo -e "$*" >>${logFile}
}

getLogicPlain() {
 echo "${logicPlain[${xyKey}]:-0}"
}

setLogicPlain() {
 bitMapCode=bm${charShortCode} 
 logicPlain[${xyKey}]=$((${logicPlain[${xyKey}]:-0}|${!bitMapCode}))
}

setDisplayPlain() {
 xyKeyChar="u${bitMap[$1]#bm}"
 displayPlain[${xyKey}]="$(echo -e "\u${!xyKeyChar}")"
}

getDisplayPlain() {
 echo -ne "${displayPlain[${xyKey}]:-" "}"
}

drawChar() {
 charShortCode=$1 dcx=$2 dcy=$3
 xyKey="$dcx,$dcy"
   [ ${h} -eq 1 -a ${w} -gt 1 ] && charShortCode=HCL
   [ ${w} -eq 1 -a ${h} -gt 1 ] && charShortCode=VCL
 setLogicPlain ${charShortCode}
 setDisplayPlain $(getLogicPlain)
 printChar $dcx $dcy "$(getDisplayPlain)"
}

# This is a temporary routine
# Provide: X Y coordinates
printChar() {
# Need to write my own tput 
 tput cup $2 $1 ; echo -ne "${3}"
}

# Provide: X Y W H
drawBox() {
 declare -i x=$1 y=$2 w=$3 h=$4
 declare -i xAw=x+w-1
 declare -i yAh=y+h-1

# Work out corner coordinates
 declare -i xTLC=x yTLC=y
 declare -i xTRC=xAw yTRC=y
 declare -i xBLC=x yBLC=yAh
 declare -i xBRC=xAw yBRC=yAh

# Draw corners
 drawChar TLC $xTLC $yTLC
 drawChar TRC $xTRC $yTRC
 drawChar BLC $xBLC $yBLC
 drawChar BRC $xBRC $yBRC

# Draw Top and bottom horizontal lines
 declare -i cX=x
 declare -i cY=y
 cX=xTLC+1
   while [ ${cX} -le $((xTRC-1)) ]
   do
     drawChar HCL $cX $yTLC
     drawChar HCL $cX $yBLC
     cX+=1 
   done
# Draw Left and right vertical lines
 cY=yTLC+1
   while [ ${cY} -le $((yBLC-1)) ]
   do
     drawChar VCL $xTLC $cY
     drawChar VCL $xTRC $cY
     cY+=1 
   done
}

#####################################################\
#############################
##
#	START HERE

declare -A logicPlain displayPlain

# Test code to just show how the code works.
# All you really need to do is issue the drawBox line below with x y width and height values.
# Top left corner of the screen screen is 0,0.  Minimum value for w and h is 1 - same square.
declare -i maxCols=$(tput cols) count=0
declare -i maxRows=$(tput lines)
  while :
  do count+=1
      if [ $((${count}%100)) -eq 0 ]
      then
        unset logicPlain displayPlain
        declare -A logicPlain displayPlain
        clear
      fi

    x=$((RANDOM%(maxCols-8)))
    y=$((RANDOM%(maxRows-8)))
    w=$(($((RANDOM%(maxCols-x)+1))%20+1))
    h=$(($((RANDOM%(maxRows-y-1)+1))%20+1))
    drawBox $x $y $w $h
  done

