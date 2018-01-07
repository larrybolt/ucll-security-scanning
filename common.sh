#!/bin/bash
# source: https://gist.github.com/tiveone/2506075

function ::netmask2cidr()
{
  case $1 in
      0x*)
      local hex=${1#0x*} quad=
      while [ -n "${hex}" ]; do
        local lastbut2=${hex#??*}
        quad=${quad}${quad:+.}0x${hex%${lastbut2}*}
        hex=${lastbut2}
      done
      set -- ${quad}
      ;;
  esac

  local i= len=
  local IFS=.
  for i in $1; do
    while [ ${i} != "0" ]; do
      len=$((${len} + ${i} % 2))
      i=$((${i} >> 1))
    done
  done

  echo "${len}"
}

# source: https://forum.openwrt.org/viewtopic.php?pid=220781#p220781
mask2cdr ()
{
   # Assumes there's no "255." after a non-255 byte in the mask
   local x=${1##*255.}
   set -- 0^^^128^192^224^240^248^252^254^ $(( (${#1} - ${#x})*2 )) ${x%%.*}
   x=${1%%$3*}
   echo $(( $2 + (${#x}/4) ))
}


cdr2mask ()
{
   # Number of args to shift, 255..255, first non-255 byte, zeroes
   set -- $(( 5 - ($1 / 8) )) 255 255 255 255 $(( (255 << (8 - ($1 % 8))) & 255 )) 0 0 0
   [ $1 -gt 1 ] && shift $1 || shift
   echo "${1-0}.${2-0}.${3-0}.${4-0}"
}

# source: https://stackoverflow.com/a/15429733
networkip ()
{
  IFS=. read -r i1 i2 i3 i4 <<< "$1"
  IFS=. read -r m1 m2 m3 m4 <<< "$2"
  printf "%d.%d.%d.%d\n" "$((i1 & m1))" "$((i2 & m2))" "$((i3 & m3))" "$((i4 & m4))"
}
