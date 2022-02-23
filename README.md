# Try to build ES with x-pack bypass

## Quickstart

   ```
   git clone --single-branch --branch bitnami https://github.com/scila1996/es-rebuild.git
   docker build --build-arg es_version=7.15.2-debian-10-r0 .
   ```
   
## Build from Server/VM

Just run and specify version to `es_version` environment variable

   ```
   chmod +x build.sh
   es_version=7.15.2 ./build.sh 
   ```


## Build from Docker image

Set `es_version` argument to version of docker image tag from bitnami. See here https://hub.docker.com/r/bitnami/elasticsearch/tags

   ```
   docker build --build-arg es_version=7.15.2-debian-10-r0 .
   ```
   
## Notes

* Only support with image from /bitnami
* Do not use in production
