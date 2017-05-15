### 3rdparty components

To add a component:

1. Create a dir with a build.sh script.
2. ON TeamCity create a two (armv7l, x86_64) configurations by extending corresponding templates.

Result:

- ARM build are automatically created by tools scripts.
- Artifacts are automatically uploaded to 3rdparty.syncloud.org/[app]-[arch].tar.gz