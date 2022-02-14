build_image() {
  name=$1
  replaced=${name/\//"-"}
  docker buildx build --pull --platform=linux/$1 --tag=philiplehmann/mailcatcher:v0.8.1-$replaced .
  docker tag philiplehmann/mailcatcher:v0.8.1-$replaced philiplehmann/mailcatcher:latest-$replaced
}
export -f build_image

parallel -kj6 build_image ::: amd64 arm/v5 arm/v7 arm64/v8 mips64le ppc64le s390x

# 386 - segment fault on mailcatcher build

deploy_image() {
  name=$1
  replaced=${name/\//"-"}
  docker push philiplehmann/mailcatcher:latest-$replaced
  docker push philiplehmann/mailcatcher:v0.8.1-$replaced
}
export -f deploy_image

parallel -kj6 deploy_image ::: amd64 arm/v5 arm/v7 arm64/v8 mips64le ppc64le s390x

docker manifest create --amend philiplehmann/mailcatcher:v0.8.1 \
                               philiplehmann/mailcatcher:v0.8.1-amd64 \
                               philiplehmann/mailcatcher:v0.8.1-arm/v5 \
                               philiplehmann/mailcatcher:v0.8.1-arm/v7 \
                               philiplehmann/mailcatcher:v0.8.1-arm64/v8 \
                               philiplehmann/mailcatcher:v0.8.1-mips64le \
                               philiplehmann/mailcatcher:v0.8.1-ppc64le \
                               philiplehmann/mailcatcher:v0.8.1-s390x

docker manifest push philiplehmann/mailcatcher:v0.8.1

docker manifest create --amend philiplehmann/mailcatcher:latest \
                               philiplehmann/mailcatcher:latest-amd64 \
                               philiplehmann/mailcatcher:latest-arm/v5 \
                               philiplehmann/mailcatcher:latest-arm/v7 \
                               philiplehmann/mailcatcher:latest-arm64/v8 \
                               philiplehmann/mailcatcher:latest-mips64le \
                               philiplehmann/mailcatcher:latest-ppc64le \
                               philiplehmann/mailcatcher:latest-s390x

docker manifest push philiplehmann/mailcatcher:latest
