# Try to build ES with bypass license

## How to build

1. Pull this repo

   ```git pull https://github.com/scila1996/es-rebuild.git```
   
2. Edit image version and ES version in Dockerfile

   > vim Dockerfile
   
   replace `FROM` and `es_version` section
   
3. Ok . Let run to build

   ```docker build .```
   
## Notes

*Do not use in production*
