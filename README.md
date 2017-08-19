### 3rdparty components

To add a component:

1. Create a dir with a build.sh script.

### Running local drone build

Get drone cli binary: http://docs.drone.io/cli-installation/
````
sudo DOCKER_API_VERSION=1.24 arch=amd64 project=[project] /path/to/drone exec

Result:

- Artifacts are automatically uploaded to 3rdparty.syncloud.org/[app]-[arch].tar.gz