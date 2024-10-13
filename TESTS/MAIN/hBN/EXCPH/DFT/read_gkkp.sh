

kind="qindx_C"

ncdump_fx_t GKKP_$kind/ndb.elph_gkkp_expanded > GKKP_$kind/ndb.elph_gkkp_expanded.dat
for iq in {1..9}; do
  ncdump GKKP_$kind/ndb.elph_gkkp_expanded_fragment_$iq > GKKP_$kind/ndb.elph_gkkp_expanded_fragment_$iq.dat
done
