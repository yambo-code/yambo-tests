#!/usr/bin/bash
#
./driver.pl -i | grep '#' > TMP
while read p; do
  MOD=`echo "$p" | sed 's/#//g'| sed -e 's/^\w*\ *//'| cut -d " " -f1 | sed 's/://g'`
  if [[ "$MOD" == *"SIO"* ]]; then
   CONF="serial_io.sh"
  fi
  if [[ "$MOD" == *"PIO"* ]]; then
   CONF="parallel_io.sh"
  fi
  rm -fr compile_dir
  ./scripts/launcher.tcsh -y develop -t develop -f ext-libs -c $CONF -m $MOD
done < TMP
