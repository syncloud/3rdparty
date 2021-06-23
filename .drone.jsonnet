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
            image: "syncloud/platform-" + arch,
	        commands: [
              "./" + name + "/test.sh"
	        ]
	      },
         {
	        name: "test-jessie",
            image: "syncloud/platform-jessie-" + arch,
	        commands: [
              "./" + name + "/test.sh"
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
        },
        {
            name: "publish to github",
            image: "plugins/github-release",
            settings: {
                api_key: {
                    from_secret: "github_token"
                },
                files: name + "/*.tar.gz",
                title: "1"
            },
            when: {
                branch: [ "master" ]
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
    build(item.project, arch, item.image, item.native)
    for item in [
        #{project: "asterisk", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "bind9", image: "debian:buster-backports", archs: ["arm", "amd64"], native: true},
        #{project: "dovecot", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "gcc-5", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "git", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "gptfdisk", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "ImageMagick", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "libvips", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "mariadb", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "mongodb", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "mongodb-3.4", image: "syncloud/build-deps-buster", archs: ["amd64"], native: false},
        #{project: "mongodb-3.6", image: "syncloud/build-deps-buster", archs: ["amd64"], native: false},
        #{project: "mongodb-4", image: "syncloud/build-deps-buster", archs: ["amd64"], native: false},
        #{project: "nginx", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "nodejs", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "opendkim", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "openldap", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "openvpn", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "openssl", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "phantomjs", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "php", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        {project: "php7", image: "debian:jessie", archs: ["arm", "amd64"], native: true},
        #{project: "php8", image: "gcc:10", archs: ["arm", "amd64"], native: true},
        #{project: "postgresql", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "postgresql-10", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "PyYAML", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "python", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "python3", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "redis", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "rsyslog", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
        #{project: "sqlite", image: "syncloud/build-deps", archs: ["arm", "amd64"], native: false},
    ]
    for arch in item.archs
]
