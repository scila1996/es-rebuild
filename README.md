# Try to build ES with bypass license

## Quickstart

   ```
   git clone https://github.com/scila1996/es-rebuild.git
   docker build --build-arg es_version=7.14.2-debian-10-r1 .
   ```
   
## Build from Server/VM

Just run and specify version to `es_version` environment variable

   ```
   chmod +x build.sh
   es_version=7.14.2 ./build.sh 
   ```


## Build from Docker image

Set `es_version` argument to version of docker image tag from bitnami. See here https://hub.docker.com/r/bitnami/elasticsearch/tags

   ```
   docker build --build-arg es_version=7.14.2-debian-10-r1 .
   ```
   
## Notes

* Use for image from elastic.co
* Do not use in production
