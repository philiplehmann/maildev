docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

docker buildx create --platform linux/arm64,linux/amd64,linux/ppc64le,linux/s390x,linux/arm/v7,linux/arm/v6 --name maildev-builder
docker buildx use maildev-builder
docker buildx build --push --no-cache --platform=linux/arm64,linux/amd64,linux/ppc64le,linux/s390x,linux/arm/v7,linux/arm/v6 --tag=philiplehmann/maildev:v2.0.5 .

docker buildx imagetools create registry.hub.docker.com/philiplehmann/maildev:v2.0.5 --tag registry.hub.docker.com/philiplehmann/maildev:latest