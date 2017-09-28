name             "sentry"
maintainer       "Openhood S.E.N.C"
maintainer_email "jonathan@openhood.com"
license          "Apache 2.0"
description      "Installs/Configures Sentry realtime error logging and aggregation platform"
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          "0.4.1"

supports 'ubuntu'

depends 'poise-python'
depends 'runit', '>= 1.1.6'
suggests 'redisio'
