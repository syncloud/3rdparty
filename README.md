### 3rdparty components

To add a component:

1. Create a dir with a build.sh script.

### Running local drone build

Get drone cli binary: http://docs.drone.io/cli/install
```
sudo /path/to/drone exec --pipeline=[project]-[arch]
```

For example
```
sudo /path/to/drone exec --pipeline=mongo-4-amd64 --include=build
```
