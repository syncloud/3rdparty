local build(name, arch) = {
    platform: {
        os: "linux",
        	arch: arch
    },
    kind: "pipeline",
    name: name + "-" + arch,
    steps: [
        {
	          name: "build",
            image: "syncloud/build-deps-" + arch,
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
    build(project, arch) for arch in [ 
    "arm",
    "amd64"
    ] for project in [ 
#"ImageMagick",
#"PyYAML",
#"asterisk",
#"dovecot",
#"git",
#"nginx",
#"nodejs",
#"openldap",
#"openssl",
#"php",
"php7",
#"postfix",
#"postgresql"
#"postgresql-10",
#"python",
#"python3",
#"redis",
#"rsyslog",
#"ruby",
#"uwsgi",
#"mongodb",
#"mongodb-3.4"
#"phantomjs",
#"mariadb",
#"libvips",
#"sqlite",
#"bind9",
#"openvpn",
#"opendkim",
    ]
]
