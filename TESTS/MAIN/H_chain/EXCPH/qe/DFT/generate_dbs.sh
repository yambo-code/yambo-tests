pw=pw.x_dev
ph=ph.x_dev

START="$(date +%s)"

echo "$pw < inputs/01_scf.in > output/01_scf.out"
$pw < inputs/01_scf.in > output/01_scf.out

echo "$ph < inputs/02_dfpt.in > output/02_dfpt.out"
$ph < inputs/02_dfpt.in > output/02_dfpt.out

echo "$ph < inputs/03_elph.in > output/03_elph.out"
$ph < inputs/03_elph.in > output/03_elph.out

END="$(date +%s)"

DURATION="$(( ${END} - ${START} ))"

echo "Duration: $DURATION" >> generate_dbs.time


