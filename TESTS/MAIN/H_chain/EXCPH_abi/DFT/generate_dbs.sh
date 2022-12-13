
abi=abinit_ibte
mrdb=mrgddb_ibte
mrdv=mrgdv_ibte
a2y=a2y_excph

$abi inputs/01_hchain.abi > logs/01_hchain.log
$mrdb < inputs/02_mrgddb.in > logs/02_mrgddb.log
$mrdv < inputs/03_mrgdv.in > logs/03_mrgdv.log
$abi inputs/04_hchain_elph.abi > logs/04_hchain_elph.out
$abi  inputs/05_hchain_expwfk.abi > logs/05_hchain_expwfk.log

cd io_dir
ln -s 04_hchain_elph_o_GSTORE.nc 05_hchain_expwfk_o_GKKP.nc
$a2y -F 05_hchain_expwfk_o_WFK.nc
cd ..

mv io_dir/SAVE ../
mv io_dir/GKKP_abinit ../GKKP_expanded
