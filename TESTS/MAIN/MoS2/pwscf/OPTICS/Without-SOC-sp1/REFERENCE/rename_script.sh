
old_name=05_GW
new_name=06_GW_slabz_rim

for file in *${old_name}*; do
  echo $file
  new_file=$(echo ${file} |sed -e "s/${old_name}/${new_name}/g")
  echo $new_file
  git mv $file $new_file
done
