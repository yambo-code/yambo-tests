#!/usr/bin/tcsh
#
set robot = $1
while ( $robot != 0 )
 if ( -e ${robot}_DONE ) then
  set robot = 0
 else
  foreach exe ( yambo ypp a2y p2y e2y)
   #echo "KILLING $robot $exe"
if (! -f KILLER_${exe}_${robot}.awk) then
cat << EOF > KILLER_${exe}_${robot}.awk
{
 if (index(\$3,"$exe")>0 && index(\$3,"$robot")>0)
 {
  if (\$1 > 600) { print \$2};
 }
}
EOF
endif
   set NL=`ps -eo etimes,pid,cmd:150 | awk -f KILLER_${exe}_${robot}.awk`
   if ( "$NL" != "") then
     ps -eo etimes,pid,cmd:150 | awk -f KILLER_${exe}_${robot}.awk | xargs kill -9
   endif
  end
  sleep 60
 endif
end
