local build(name, arch, image) = {
    platform: {
        os: "linux",
        	arch: arch
    },
    kind: "pipeline",
    name: name + "-" + arch,
    steps: [
        {
	          name: "build",
            image: "syncloud/" + image + "-" + arch,
	          commands: [
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
    build(item.project, arch, item.image)
    for arch in [
        "arm",
        "amd64"
    ] for item in [ 
        #{project: "ImageMagick", image: "build-deps"},
        #{project: "PyYAML", image: "build-deps"},
        #{project: "asterisk", image: "build-deps"},
        #{project: "dovecot", image: "build-deps"},
        #{project: "git", image: "build-deps"},
        #{project: "nginx", image: "build-deps"},
        #{project: "nodejs", image: "build-deps"},
        #{project: "openldap", image: "build-deps"},
        #{project: "openssl", image: "build-deps"},
        #{project: "php", image: "build-deps"},
        #{project: "php7", image: "build-deps"},
        #{project: "postgresql", image: "build-deps"},
        #{project: "postgresql-10", image: "build-deps"},
        #{project: "python", image: "build-deps"},
        #{project: "python3", image: "build-deps"},
        #{project: "redis", image: "build-deps"},
        #{project: "rsyslog", image: "build-deps"},
        #{project: "uwsgi", image: "build-deps"},
        #{project: "mongodb", image: "build-deps"},
        #{project: "mongodb-3.4", image: "build-deps-buster"},
        #{project: "phantomjs", image: "build-deps-buster"},
        #{project: "mariadb", image: "build-deps-buster"},
        #{project: "libvips", image: "build-deps-buster"},
        #{project: "sqlite", image: "build-deps-buster"},
        #{project: "bind9", image: "build-deps-buster"},
        #{project: "openvpn", image: "build-deps-buster"},
        #{project: "opendkim", image: "build-deps-buster"},
    ]
]
