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
	    name: "upload",
            image: "syncloud/build-deps-" + arch,
	    environment: {
                ARTIFACT_SSH_KEY: {
		    from_secret: "ARTIFACT_SSH_KEY"
		}
	    },
            commands: [
                "cd " + name,
                "../upload.sh " + name + "-*.tar.gz"
	    ]
	}
    ]
};

[ 
    build(project, arch) for arch in [ 
    "arm",
    "amd64"
    ] for project in [ 
#   - ImageMagick
#   - PyYAML
#   - asterisk
#   - dovecot
#   - dovecot_snap
#   - git
#   - nginx
#   - nodejs
#   - openldap
#   - openssl
#   - php
#    "php7",
#   - postfix
#   - postgresql
#   - postgresql-9.5
#   - python
#   - python3
#   - redis
#   - rsyslog
#   - ruby
#   - uwsgi
#   - mongodb
#   - phantomjs
#   - mariadb
#   - libvips
#"sqlite",
"bind9",
    ]
]
