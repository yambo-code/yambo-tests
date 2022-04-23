

for kind in "qindx_B" "qindx_S" ; do
  ncdump_fx_t GKKP_$kind/ndb.elph_gkkp_expanded > GKKP_$kind/ndb.elph_gkkp_expanded.dat
  for iq in {1..9}; do
    ncdump_fx_t GKKP_$kind/ndb.elph_gkkp_expanded_fragment_$iq > GKKP_$kind/ndb.elph_gkkp_expanded_fragment_$iq.dat
  done
done
