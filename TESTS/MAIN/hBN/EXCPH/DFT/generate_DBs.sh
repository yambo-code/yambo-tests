pw.x_dev < input/hBN.scf.in > hBN.scf.out
pw.x_dev < input/hBN.nscf.in > hBN.nscf.out
ph.x_dev < input/hBN.phonon.in > hBN.phonon.out
ph.x_dev < input/hBN.dvscf.in > hBN.dvscf.out
cd bn
p2y_excoh
yambo_excph  -F ../../MORE_inputs/01_setup
ypp_ph_excph -F ../../MORE_inputs/02_gkkp_convert
