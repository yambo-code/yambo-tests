#!/usr/bin/tcsh
#
set robot = $1
while ( $robot != 0 )
 if ( -e ${robot}_DONE ) then
  set robot = 0
 else
  echo "KILLING $ctrl"
  foreach exe ( yambo ypp a2y p2y e2y )
   kill -9 $(ps -eo comm,pid,etimes | awk '/^exe/ {if ($3 > 1200) { print $2}}')
  end
  sleep 300
 endif
end
