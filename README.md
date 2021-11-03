# Try to build ES with bypass license

## How to build

1. Pull this repo

   ```git pull https://github.com/scila1996/es-rebuild.git```
   
2. Edit image version in Dockerfile.

   > vim Dockerfile
   
   replace value in `FROM` instruction
   
3. Ok . Let run to build

   ```docker build .```
   
## Notes

* Only support for image from /bitnami
* Do not use in production
