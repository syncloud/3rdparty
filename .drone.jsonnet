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
            image: image,
	        commands: [
              "./" + name + "/build.sh"
	        ],
	        volumes: [
                {
                    name: "docker",
                    path: "/usr/bin/docker"
                },
                {
                    name: "docker.sock",
                    path: "/var/run/docker.sock"
                }
            ]
	    },
        {
	        name: "test",
          image: image,
	        commands: [
              "./" + name + "/test.sh"
	        ],
          when: {
              status: [ "failure", "success" ]
            }
	    },
        {
	        name: "test buster",
          image: "debian:buster-slim",
	        commands: [
              "./" + name + "/test.sh"
	        ],
           when: {
              status: [ "failure", "success" ]
            }
	    },
        {
	        name: "test platform",
          image: "syncloud/platform-" + arch + ":latest",
	        commands: [
              "./" + name + "/test.sh"
	        ],
           when: {
              status: [ "failure", "success" ]
            }
	    },
      	{
            name: "artifact",
            image: "appleboy/drone-scp:latest",
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
        },
        {
            name: "publish to github",
            image: "plugins/github-release:latest",
            settings: {
                api_key: {
                    from_secret: "github_token"
                },
                files: name + "/*.tar.gz",
                overwrite: true,
                file_exists: "overwrite"
            },
            when: {
                event: [ "tag" ]
            }
        }
    ],
    volumes: [
        {
            name: "dbus",
            host: {
                path: "/var/run/dbus"
            }
        },
        {
            name: "docker",
            host: {
                path: "/usr/bin/docker"
            }
        },
        {
            name: "docker.sock",
            host: {
                path: "/var/run/docker.sock"
            }
        }
    ]
};

[ 
    build(item.project, item.arch, item.image, item.native)
    for item in [
        #{project: "asterisk", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "bind9", image: "debian:buster-backports", arch: "arm"},
        #{project: "bind9", image: "debian:buster-backports", arch: "amd64"},
        #{project: "bind9", image: "debian:buster-backports", arch: "arm64"},
        {project: "btrfs", image: "debian:buster", arch: "arm64"},
        {project: "btrfs", image: "debian:buster", arch: "arm"},
        {project: "btrfs", image: "debian:buster", arch: "amd64"},
        #{project: "dovecot", image: "debian:buster", arch: "arm"},
        #{project: "dovecot", image: "debian:buster", arch: "amd64"},
        #{project: "dovecot", image: "debian:buster", arch: "arm64"},
        #{project: "gcc-5", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "git", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "gptfdisk", image: "syncloud/build-deps-arm", arch: "arm"},
        #{project: "gptfdisk", image: "syncloud/build-deps-amd64", arch: "amd64"},
        #{project: "gptfdisk", image: "syncloud/build-deps-buster-arm64", arch: "arm64"},
        #{project: "ImageMagick", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "libvips", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "mariadb", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "mongodb", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "mongodb-3.4", image: "syncloud/build-deps-buster", archs: ["amd64"], native: false},
        #{project: "mongodb-3.6", image: "syncloud/build-deps-buster", archs: ["amd64"], native: false},
        #{project: "mongodb-4", image: "syncloud/build-deps-buster", archs: ["amd64"], native: false},
        #{project: "nginx", image: "syncloud/build-deps-arm", arch: "arm"},
        #{project: "nginx", image: "syncloud/build-deps-amd64", arch: "amd64"},
        #{project: "nginx", image: "syncloud/build-deps-buster-arm64", arch: "arm64"},
        #{project: "nodejs", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "opendkim", image: "debian:buster", arch: "arm"},
        #{project: "opendkim", image: "debian:buster", arch: "amd64"},
        #{project: "opendkim", image: "debian:buster", arch: "arm64"},
        #{project: "openldap", image: "syncloud/build-deps-arm", arch: "arm"},
        #{project: "openldap", image: "syncloud/build-deps-amd64", arch: "amd64"},
        #{project: "openldap", image: "syncloud/build-deps-buster-arm64", arch: "arm64"},
        #{project: "openvpn", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "openssl", image: "syncloud/build-deps-arm", arch: "arm"},
        #{project: "openssl", image: "syncloud/build-deps-amd64", arch: "amd64"},
        #{project: "openssl", image: "syncloud/build-deps-buster-arm64", arch: "arm64"},
        #{project: "phantomjs", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "php", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "php7", image: "syncloud/build-deps-arm", arch: "arm"},
        #{project: "php7", image: "syncloud/build-deps-amd64", arch: "amd64"},
        #{project: "php7", image: "syncloud/build-deps-buster-arm64", arch: "arm64"},
        #{project: "php8", image: "gcc:10", archs: ["arm", "amd64"], native: true},
        #{project: "postgresql", image: "debian:buster-slim", arch: "arm"},
        #{project: "postgresql", image: "debian:buster-slim", arch: "amd64"},
        #{project: "postgresql", image: "debian:buster-slim", arch: "arm64"},
        #{project: "postgresql-10", image: "debian:buster-slim", arch: "arm"},
        #{project: "postgresql-10", image: "debian:buster-slim", arch: "amd64"},
        #{project: "postgresql-10", image: "debian:buster-slim", arch: "arm64"},
        #{project: "PyYAML", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "python", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "python3", image: "syncloud/build-deps-arm", arch: "arm"},
        #{project: "python3", image: "syncloud/build-deps-amd64:2021.07", arch: "amd64"},
        #{project: "python3", image: "syncloud/build-deps-arm64:2021.07", arch: "arm64"},
        #{project: "redis", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "rsyslog", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "sqlite", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
    ]
]

