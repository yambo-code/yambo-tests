#!/usr/bin/tcsh
#
cd  /scratch/marini/yambo-tests-robot/
#
set ybranch="master"
set flow="validate"
#
@ n = 0
while ( $n < $#argv)
 @ n += 1
 if ( "$argv[$n]" == "-y" ) then
  @ n += 1
  set ybranch="$argv[$n]"
  set tbranch="$ybranch"
 endif
 if ( "$argv[$n]" == "-t" ) then
  @ n += 1
  set tbranch="$argv[$n]"
 endif
 if ( "$argv[$n]" == "-m" ) then
  @ n += 1
  set module="$argv[$n]"
 endif
 if ( "$argv[$n]" == "-f" ) then
  @ n += 1
  set flow="$argv[$n]"
 endif
end
#
#echo "Y branch: $ybranch"
#echo "T branch: $tbranch"
#echo "module  : $module"
#echo "flow    : $flow"
#exit 0
#
cat << EOF > script.awk
{
if (NR==1 || index(\$0,"END")>0) {print_me="no"};
if (index(\$0,"$module")>0){
  print_me="yes";
  next;
}
if (NR       == 1    ){print "module purge"};
if (print_me == "yes"){print "module load "\$0 };
}
EOF
cat ROBOTS/baym-robot/marini/MODULES | awk -f script.awk > module.tcsh
chmod u+x module.tcsh
source module.tcsh
rm -f module.tcsh script.awk
git checkout $tbranch
git pull
./driver.pl -flow $flow -report -branch $ybranch -nice -newer 300 -input -safe -host baym-robot
