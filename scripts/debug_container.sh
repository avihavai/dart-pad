scripts_dir=$(dirname $0)

container_name="$(cat $scripts_dir/container_name.txt)"
image_name="$(cat $scripts_dir/image_name.txt)"

docker run -it --rm --entrypoint /bin/bash --name $container_name $image_name
