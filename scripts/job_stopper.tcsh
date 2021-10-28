#!/usr/bin/tcsh
#
set robot = $1
while ( $robot != 0 )
 if ( -e ${robot}_DONE ) then
  set robot = 0
 else
  foreach exe ( yambo ypp a2y p2y e2y)
   #echo "KILLING $robot $exe"
if (! -f KILLER_$exe.awk) then
cat << EOF > KILLER_$exe.awk
{
 if (index(\$3,"$exe")>0 && index(\$1,"$robot")>0)
 {
  if (\$3 > 1800) { print \$1};
 }
}
EOF
endif
   set NL=`ps -eo comm,pid,etimes | awk -f KILLER_$exe.awk`
   if ( $NL > ) then
     ps -eo comm,pid,etimes | awk -f KILLER_$exe.awk | xargs kill -9
   endif
  end
  sleep 60
 endif
end
