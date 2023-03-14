echo "pw.x_dev < input/hBN.scf.in > hBN.scf.out"
pw.x_dev < input/hBN.scf.in > hBN.scf.out
echo "pw.x_dev < input/hBN.nscf.in > hBN.nscf.out"
pw.x_dev < input/hBN.nscf.in > hBN.nscf.out
echo "ph.x_dev < input/hBN.phonon.in > hBN.phonon.out"
ph.x_dev < input/hBN.phonon.in > hBN.phonon.out
echo "ph.x_dev < input/hBN.dvscf.in > hBN.dvscf.out"
ph.x_dev < input/hBN.dvscf.in > hBN.dvscf.out
cd bn.save
echo "p2y_excph"
p2y_excph
echo "yambo_excph  -F ../../MORE_inputs/01_setup"
yambo_excph  -F ../../MORE_inputs/01_setup
echo "ypp_ph_excph -F ../../MORE_inputs/02_gkkp_convert"
ypp_ph_excph -F ../../MORE_inputs/02_gkkp_convert
