local build(name, arch, image, native) = {
    platform: {
        os: "linux",
       	arch: arch
    },
    kind: "pipeline",
    name: name + "-" + arch,
    steps: [
        {
	        name: "build",
            image: if native then image else image + "-" + arch,
	        commands: [
              "apk add --no-cache bash || true",
              "./build.sh " + name
	        ]
	      },
      	{
            name: "artifact",
            image: "appleboy/drone-scp",
            settings: {
                host: {
                    from_secret: "artifact_host"
                },
                username: "artifact",
                key: {
                    from_secret: "artifact_key"
                },
                timeout: "2m",
                command_timeout: "2m",
                target: "/home/artifact/repo/3rdparty/${DRONE_BUILD_NUMBER}-" + arch,
                source: name + "/*.tar.gz",
		             strip_components: 1
            },
            when: {
              status: [ "failure", "success" ]
            }
        }
    ]
};

[ 
    build(item.project, arch, item.image, item.native)
    for item in [
        #{project: "asterisk", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        {project: "bind9", image: "alpine:3.12", archs: ["arm", "amd64"], native: true},
        #{project: "dovecot", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "gcc-5", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "git", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "gptfdisk", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "ImageMagick", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "libvips", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "mariadb", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "mongodb", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "mongodb-3.4", image: "syncloud/build-deps-buster", archs: ["amd64"]},
        #{project: "mongodb-3.6", image: "syncloud/build-deps-buster", archs: ["amd64"]},
        #{project: "mongodb-4", image: "syncloud/build-deps-buster", archs: ["amd64"]},
        #{project: "nginx", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "nodejs", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "opendkim", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "openldap", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "openvpn", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "openssl", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "phantomjs", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "php", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "php7", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "postgresql", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "postgresql-10", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "PyYAML", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "python", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "python3", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "redis", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "rsyslog", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
        #{project: "sqlite", image: "syncloud/build-deps", archs: ["arm", "amd64"]},
    ]
    for arch in item.archs
]
