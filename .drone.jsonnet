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
    for item in [
        #{project: "ImageMagick", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "PyYAML", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "asterisk", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "dovecot", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "git", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "nginx", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "nodejs", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "openldap", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "openssl", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "php", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "php7", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "postgresql", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "postgresql-10", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "python", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "python3", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "redis", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "rsyslog", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "mongodb", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "mongodb-3.4", image: "build-deps-buster", archs: ["arm", "amd64"]},
        {project: "mongodb-4", image: "build-deps", archs: ["amd64"]},
        #{project: "phantomjs", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "mariadb", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "libvips", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "sqlite", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "bind9", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "openvpn", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "opendkim", image: "build-deps", archs: ["arm", "amd64"]},
        #{project: "gptfdisk", image: "build-deps", archs: ["arm", "amd64"]},
    ]
    for arch in item.archs
]
