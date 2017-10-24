{
if (NR==0) {DATA="no"}
if (index($0,"data")!=0) {DATA="yes"}
gsub("{"," ",$0)
gsub("}"," ",$0)
gsub(","," ",$0)
gsub(";"," ",$0)
gsub(":"," ",$0)
gsub("data"," ",$0)
gsub("e","E",$0)
na=split($0,a)
if (DATA=="yes" && na>0)
{
 i=1
 if (a[2]=="=") {i=3}
 while (i<=na)
 {
   print " " a[i]
   i++
 }
}
}
