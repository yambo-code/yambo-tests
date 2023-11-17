#! /bin/bash
#
if [ ! -d SCF.xml ] ; then
 cat inputs/scf.in inputs/k_444 > scf.in
 pw.x < scf.in > scf.out
fi

if [ ! -d NSCF_444.xml ] ; then
 mkdir NSCF.save
 cp  SCF.save/data* SCF.save/charge* NSCF.save
 cat inputs/nscf.in inputs/k_444 > nscf_444.in
 pw.x < nscf_444.in > nscf_444.out
 mv NSCF.save NSCF_444.save
 mv NSCF.wfc1 NSCF_444.wfc1
 mv NSCF.xml NSCF_444.xml
fi

if [ ! -d NSCF_gw.xml ] ; then
 mkdir NSCF.save
 cp  SCF.save/data* SCF.save/charge* NSCF.save
 cat inputs/nscf.in inputs/k_gw > nscf_gw.in
 pw.x < nscf_gw.in > nscf_gw.out
 mv NSCF.save NSCF_gw.save
 mv NSCF.wfc1 NSCF_gw.wfc1
 mv NSCF.xml NSCF_gw.xml
fi

