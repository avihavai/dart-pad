scripts_dir=$(dirname $0)

container_name="$(cat $scripts_dir/container_name.txt)"

docker stop $container_name
