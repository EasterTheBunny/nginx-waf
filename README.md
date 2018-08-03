## Build
Building the docker image can be done by the following:


`docker build --tag [image_name] .`

Where [image_name] is the image name you use for images based on this one.

## Extend
To extend the functionality of this image, create a new image to use this one and replace `main.conf` and `nginx.conf`. If you need to disable core rule sets, replace `crs_includes.conf`.
