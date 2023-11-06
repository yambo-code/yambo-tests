#!/usr/bin/bash
#
USER_mod="all"
while getopts "hm:" arg; do
  case $arg in
    h)
      echo ""
      echo "$0 -m MODULE (optional)"
      echo ""
      exit 0
      ;;
    m)
      USER_mod=$OPTARG
      ;;
  esac
done
#
./driver.pl -i | grep '#' > TMP
#
while read p; do
  MOD=`echo "$p" | sed 's/#//g'| sed -e 's/^\w*\ *//'| cut -d " " -f1 | sed 's/://g'`
  if [[ "$MOD" == *"SIO"* ]]; then
   CONF="serial_io.sh"
  fi
  if [[ "$MOD" == *"PIO"* ]]; then
   CONF="parallel_io.sh"
  fi
  if [[ "$MOD" == *"NV-"* ]]; then
   CONF="CUDA.sh"
  fi
  rm -fr compile_dir
  if [[ "$MOD" == *"$USER_mod"* ]] || [[ "$USER_mod" == "all" ]] ; then
   ./scripts/launcher.tcsh -y maintain/compilation -t maintain/compilation -f ext-libs -c $CONF -m $MOD
  fi
done < TMP
