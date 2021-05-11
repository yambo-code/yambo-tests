#!/usr/bin/tcsh
#
if ( "$argv[1]" =~ clean ) then
 rm -fr 08_rt eq neq
endif
# RT 
if ( "$argv[1]" =~ rt ) then
 rm -fr 08_rt 
 yambo_rt -F INPUTS/08_rt -J 08_rt -C 08_rt
endif
#
# IP (eq@eq)
if ( "$argv[1]" =~ eq ) then
 rm -fr eq dips
 yambo_rt -F INPUTS/09_ip_eq -J eq/IP
 mkdir -p dips
 mv eq/IP/ndb.dipoles* dips/
endif
#
# IP (eq@neq)
if ( "$argv[1]" =~ Y-neq) then
 rm -fr  neq/full/*Y-*
 foreach TIME (`seq 1 20 20`)
cat << EOF > awk
{
gsub("TIME",$TIME)
print \$0
}
EOF
  awk -f awk < INPUTS/11_ip_neq > in_${TIME}
  yambo_rt -F in_${TIME} -J neq/full/Y-IP_neq_$TIME,08_rt,dips
  rm -f awk in_$TIME
 end
endif
if ( "$argv[1]" =~ YPP-neq) then
 rm -f neq/full/*YPP-*
 ypp_rt -F INPUTS/11_ip_neq_ypp_procedure -J neq/full/YPP-IP_neq,08_rt,dips
endif

#
# IP (eq@neq)
if ( "$argv[1]" =~ Y-neq-eqtrans ) then
 rm -fr  neq/eqtrans/*Y-*
 foreach TIME (`seq 1 20 20`)
cat << EOF > awk
{
gsub("TIME",$TIME)
print \$0
}
EOF
  awk -f awk < INPUTS/10_ip_neq_eq_transitions  > in_${TIME}
  yambo_rt -F in_${TIME} -J neq/eqtrans/Y-IP_neq_$TIME,08_rt,dips
  rm -f awk in_$TIME
 end
endif
if ( "$argv[1]" =~ YPP-neq-eqtrans ) then
 rm -f neq/eqtrans/*YPP-*
 ypp_rt -F INPUTS/10_ip_neq_ypp_procedure -J neq/eqtrans/YPP-IP_neq,08_rt,dips
endif

