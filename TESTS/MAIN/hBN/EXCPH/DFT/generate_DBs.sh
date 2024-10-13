pw=pw.x_dev
ph=ph.x_dev

p2y=p2y_excph
yambo=yambo_excph
yambo_ph=yambo_ph_excph
ypp_ph=ypp_ph_excph

echo "$pw < input/hBN.scf.in > hBN.scf.out"
$pw < input/hBN.scf.in > hBN.scf.out
echo "$pw < input/hBN.nscf.in > hBN.nscf.out"
$pw < input/hBN.nscf.in > hBN.nscf.out
echo "$ph < input/hBN.phonon.in > hBN.phonon.out"
$ph < input/hBN.phonon.in > hBN.phonon.out
echo "ph < input/hBN.dvscf.in > hBN.dvscf.out"
$ph < input/hBN.dvscf.in > hBN.dvscf.out
cd bn.save
echo "$p2y"
$p2y
echo "$yambo -F ../../MORE_inputs/00_setup"
$yambo -F ../../MORE_inputs/00_setup
echo "$yambo_ph  -F ../../MORE_inputs/01_setup"
$yambo_ph  -F ../../MORE_inputs/01_setup
echo "$ypp_ph -F ../../MORE_inputs/02_gkkp_convert"
$ypp_ph -F ../../MORE_inputs/02_gkkp_convert -J GKKP -C GKKP
