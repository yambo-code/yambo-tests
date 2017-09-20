#!/bin/bash
MATERIAL=Si
#
# RUNS
echo "PW ground state"
pw.x < input/01gs.in      > output/01gs.out

echo "PH phonons"
ph.x  < input/02ph.in  > output/02ph.out

echo "PW nscf"
pw.x     < input/03nscf.in    > output/03nscf.out

echo "PH electron-phonon coupling"
ph.x  < input/04elph.in    > output/04elph.out

echo "Q2R + MATDYN to apply sum-rule"
q2r.x    < input/05q2r.in     > output/05q2r.out

./generate_qpt_mesh.sh 
cat input/06matdyn.in qpt_mesh_pwscf.txt > input/06matdyn.in_here
matdyn.x < input/06matdyn.in_here  > output/06matdyn.out
#
mkdir $MATERIAL.export
mv elph_dir/s.dbph* $MATERIAL.export
mv $MATERIAL.freq $MATERIAL.export
#
cd $MATERIAL.save
p2y -a 2 -O ../$MATERIAL.export
#
cd ../$MATERIAL.export
mkdir input
#
cat > input/01init.in << EOF
setup                        # [R INI] Initialization
ElecTemp= 0.00         eV    # Electronic Temperature
% QptCoord                   # [KPT] [iku] Q-points coordinates (compatibility)
EOF
cat ../qpt_mesh_yambo.txt >> input/01init.in 
cat >> input/01init.in << EOF
%
EOF
#
cat > input/02GKKP.in << EOF
gkkp                         # [R] Electron-Phonon databases
DBsPATH= "."                 # Path to the PW el-ph databases
PHfreqF= "$MATERIAL.freq"    # PWscf format file containing the phonon frequencies
GkkpExpand                   # Expand the gkkp in the whole BZ
EOF
#
yambo_ph -F input/01init.in
ypp_ph   -F input/02GKKP.in -J GKKP  > qpt_mesh_global.txt


