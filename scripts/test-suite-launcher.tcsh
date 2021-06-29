#!/usr/bin/tcsh
cd  /scratch/marini/yambo-tests-robot/
cat << EOF > script.awk
{
if (NR==1 || index(\$0,"END")>0) {print_me="no"};
if (index(\$0,"$4")>0){
  print_me="yes";
  next;
}
if (NR       == 1    ){print "module purge"};
if (print_me == "yes"){print "module load "\$0 };
}
EOF
cat baym-robot/marini/MODULES | awk -f script.awk > module.tcsh
chmod u+x module.tcsh
source module.tcsh
rm -f module.tcsh script.awk
git checkout $3
git pull
./driver.pl -flow $1 -report -branch $2 -nice -newer 300 -input -safe -host baym-robot
