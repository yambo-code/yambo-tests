pw=pw.x_dev
ph=ph.x_dev

p2y=p2y_excph
yambo_ph=yambo_ph_excph
ypp_ph=ypp_ph_excph

START="$(date +%s)"

echo "$pw < inputs/01_scf.in > output/01_scf.out"
$pw < inputs/01_scf.in > output/01_scf.out

echo "$ph < inputs/02_dfpt.in > output/02_dfpt.out"
$ph < inputs/02_dfpt.in > output/02_dfpt.out

echo "$pw < inputs/03_nscf.in > output/03_nscf.out"
$pw < inputs/03_nscf.in > output/03_nscf.out

echo "$ph < inputs/04_elph.in > output/04_elph.out"
$ph < inputs/04_elph.in > output/04_elph.out

END="$(date +%s)"

DURATION="$(( ${END} - ${START} ))"

echo "Duration: $DURATION" >> generate_dbs.time

MATERIAL=hchain
GKKP=GKKP_expanded

mkdir $MATERIAL.export
mv elph_dir/s.dbph* $MATERIAL.export
mv $MATERIAL.freq $MATERIAL.export
#
cd $MATERIAL.save
$p2y -O ../$MATERIAL.export
#
cd ../$MATERIAL.export
mkdir input
#
cat > input/01init.in << EOF
setup                        # [R INI] Initialization
ElecTemp= 0.00         eV    # Electronic Temperature
EOF
#
cat > input/02GKKP.in << EOF
gkkp                             # [R] gkkp databases
gkkp_db                          # [R] GKKP database
#GkkpReadBare                  # Read the bare gkkp
DBsPATH= "."                     # Path to the PW el-ph databases
PHfreqF= "$MATERIAL.freq"    # PWscf format file containing the phonon frequencies
PHmodeF= "none"                  # PWscf format file containing the phonon modes
GkkpExpand                     # Expand the gkkp in the whole BZ
#GkkpExpOnlyK                  # Expand only k-points and not the q-points (that should be already in BZ)
#UseQindxB                     # Use qindx_B to expand gkkp (for testing purposes)
EOF
#
$yambo_ph -F input/01init.in
$ypp_ph   -F input/02GKKP.in -J $GKKP -C $GKKP  > qpt_mesh_global.txt

cd ../
rm -rf ../SAVE
rm -rf ../$GKKP
mv $MATERIAL.export/r_setup ../
mv $MATERIAL.export/SAVE    ../
mv $MATERIAL.export/$GKKP   ../
