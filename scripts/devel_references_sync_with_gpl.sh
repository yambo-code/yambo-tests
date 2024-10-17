#!/usr/bin/tcsh
#
set DIRS=`find . -name 'REFERENCE_gpl'`
#
foreach src ($DIRS)
 set dest=`echo $src | sed  "s/_gpl//g"`
 echo "Copying $src into $dest"
 set FILES=`find $src -type f`
 foreach obj ($FILES)
  set file=`basename $obj`
  set DF=`diff $src/$file  $dest/$file| wc -l`
  if ($DF > 0) then
   cp $src/$file $dest >& /dev/null
   git add $dest/$file >& /dev/null
  endif
 end
end
