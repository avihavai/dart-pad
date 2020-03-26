scripts_dir=$(dirname $0)

image_name="$(cat $scripts_dir/image_name.txt)"

cd ${scripts_dir}/..
docker build -t $image_name $@ .
