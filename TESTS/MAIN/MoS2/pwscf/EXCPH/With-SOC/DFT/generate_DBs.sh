
PW=pw.x_6.6
PH=ph.x_6.6

P2Y=p2y_excph
YAMBO_PH=yambo_ph_excph
YPP_PH=ypp_ph_excph

# SCF run
echo "SCF run"
$PW < input/scf.in > mos2.scf.out


# NSCF run
echo "NSCF run"
$PW < input/nscf.in > mos2.nscf.out

#
# Electron-phonon
#
echo "Electron-phonon"

# Generate SAVE and list qpts
echo "Electron-phonon: generate SAVE"
cd mos2.save
$P2Y
$YAMBO_PH  -F ../../MORE_inputs/01_setup
$YPP_PH    -F ../../MORE_inputs/02_generate_qpoints
cd ..

# Use qpts to generate phonon and dVscf matrix elements, then expand them
echo "Electron-phonon: generate dVscf"
$PH < input/phonon.in > mos2.phonon.out
$PH < input/dvscf.in >  mos2.dvscf.out
cd mos2.save
$YPP_PH -F ../../MORE_inputs/03_gkkp_convert
cd ..

