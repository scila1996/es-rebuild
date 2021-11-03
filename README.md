# Try to build ES with bypass license

## Quickstart

   ```
   git pull https://github.com/scila1996/es-rebuild.git
   docker build .
   ```
   
## Build from Server/VM

Just run and specify version to `es_version` environment variable

   ```
   chmod +x build.sh
   es_version=7.14.2 ./build.sh 
   ```


## Build from Docker image

Edit image version in Dockerfile. replace value in `FROM` instruction

   ```
   vim Dockerfile
   ```

Ok . Let run to build

   ```
   docker build .
   ```
   
## Notes

* Only support for image from /bitnami
* Do not use in production
