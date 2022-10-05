#!/usr/bin/bash
#
robot=$1
while [ $robot != 0 ]; do
 if [ -e ${robot}_DONE ]; then
  set robot = 0
 else
  for exe in yambo ypp a2y p2y e2y; do
if [ ! -f KILLER_${exe}_${robot}.awk ]; then
cat << EOF > KILLER_${exe}_${robot}.awk
{
 if (index(\$3,"$exe")>0 && index(\$3,"$robot")>0)
 {
  if (\$1 > 1200) { print \$2};
 }
}
EOF
fi
   set NL=`ps -eo etimes,pid,cmd:150 | awk -f KILLER_${exe}_${robot}.awk`
   if [ ! "$NL" == "" ]; then
     ps -eo etimes,pid,cmd:150 | awk -f KILLER_${exe}_${robot}.awk | xargs kill -9
   fi
  done
  sleep 60
 fi
done
