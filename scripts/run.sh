port=${2:-"8000"}

scripts_dir=$(dirname $0)

container_name="$(cat $scripts_dir/container_name.txt)"
image_name="$(cat $scripts_dir/image_name.txt)"

docker run --rm -p -p $port:8000 --name $container_name $image_name
