
old_name=02_BSE_KERR
new_name=02_BSE

for file in *${old_name}*; do
  echo $file
  new_file=$(echo ${file} |sed -e "s/${old_name}/${new_name}/g")
  echo $new_file
  git mv $file $new_file
done
