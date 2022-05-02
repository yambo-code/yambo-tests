
# SCF run
echo "SCF run"
pw.x_dev < input/scf.in > mos2.scf.out


# NSCF run
echo "NSCF run"
pw.x_dev < input/nscf.in > mos2.nscf.out

#
# Electron-phonon
#
echo "Electron-phonon"

# Generate SAVE and list qpts
echo "Electron-phonon: generate SAVE"
cd mos2
p2y_excph
yambo_excph  -F ../../MORE_inputs/01_setup
ypp_excph    -F ../../MORE_inputs/02_generate_qpoints
cd ..

# Use qpts to generate phonon and dVscf matrix elements, then expand them
echo "Electron-phonon: generate dVscf"
ph.x_dev < input/phonon.in > mos2.phonon.out
ph.x_dev < input/dvscf.in >  mos2.dvscf.out
cd mos2
ypp_ph_excph -F ../../MORE_inputs/02_gkkp_convert
cd ..

#
# More shifted grids
#
echo "More shifted grids"

# NSCF run shif1
echo "More shifted grids: shift 1"
mkdir mos2_s1.save
cp mos2.save/charge-density.dat mos2.save/data-file-schema.xml mos2_s1.save/
pw.x_dev < input/nscf_shift1.in > mos2.nscf_s1.out
cd mos2_s1
p2y_excph
yambo_excph  -F ../../OPTICS/With-SOC/MORE_inputs/01_setup
cd ..

# NSCF run shif1
echo "More shifted grids: shift 2"
mkdir mos2_s2.save
cp mos2.save/charge-density.dat mos2.save/data-file-schema.xml mos2_s2.save/
pw.x_dev < input/nscf_shift2.in > mos2.nscf_s2.out
cd mos2_s2
p2y_excph
yambo_excph  -F ../../OPTICS/With-SOC/MORE_inputs/01_setup
cd ..

