#
# Cookbook Name:: sentry
# Attribute:: default
#
# Copyright 2013, Openhood S.E.N.C.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_attribute "python::default"
default["sentry"]["version"] = "7.7.1"
default["sentry"]["user"] = "sentry"
default["sentry"]["group"] = "sentry"
default["sentry"]["pipname"] = "sentry"
default["sentry"]["database"]["pipdeps"] = []
default["sentry"]["plugins"] = [
  ["django-secure", "1.0.1"],
  ["django-bcrypt", "0.9.2"],
  ["django-sendmail-backend", "0.1.2"],
]
# dependencies per: https://docs.getsentry.com/on-premise/server/installation/python/
default["sentry"]["dependency"]["packages"] = [
  "python-dev",
  "gcc",
  "libjpeg-dev",
  "libxml2-dev",
  "libxslt-dev",
  "libxslt1-dev",
  "libffi-dev",
  "libyaml-dev",
  "libpq-dev", # not in docs listed but blocks sentry install
]
default["sentry"]["install_dir"] = "/opt/sentry"
default["sentry"]["filestore_dir"] = "/opt/sentry/data"
default["sentry"]["config_dir"] = "#{node["sentry"]["install_dir"]}/etc"
default["sentry"]["config_file_path"] = "#{node["sentry"]["config_dir"]}/config.py"
default["sentry"]["config_python_path"] = "#{node["sentry"]["config_dir"]}/sentry.config.py"
default["sentry"]["config_yaml_path"] = "#{node["sentry"]["config_dir"]}/config.yml"

# ENV variables for runit
default["sentry"]["env_d_path"] = "/etc/sentry.d"
default["sentry"]["env_path"] = "#{node["sentry"]["env_d_path"]}/env" 

default["sentry"]["config"]["db_engine"] = "django.db.backends.postgresql_psycopg2"
default["sentry"]["config"]["db_options"] = {autocommit: true}
default["sentry"]["config"]["admin_email"] = ""

# web server
default["sentry"]["config"]["allow_registration"] = false
default["sentry"]["config"]["allow_origin"] = false
default["sentry"]["config"]["beacon"] = false
default["sentry"]["config"]["public"] = false
default["sentry"]["config"]["web_host"] = "127.0.0.1"
default["sentry"]["config"]["web_port"] = 9000
default["sentry"]["config"]["secure_proxy_ssl_header"] = false
default["sentry"]["config"]["web_options"] = {
  "workers" => 3,
  "secure_scheme_headers" => {
    "X-FORWARDED-PROTO" => "https"
  }
}
default["sentry"]["config"]["url_prefix"] = "http://localhost:#{node["sentry"]["config"]["web_port"]}"
default["sentry"]["config"]["force_script_name"] = false

# smtp
default["sentry"]["config"]["smtp_host"] = '0.0.0.0'
default["sentry"]["config"]["smtp_port"] = '5587'
default["sentry"]["config"]["smtp_hostname"] = 'reply.getsentry.com'

default["sentry"]["config"]["email_default_from"] = "#{node["sentry"]["user"]}@#{node[:fqdn]}"
default["sentry"]["config"]["email_backend"] = "django.core.mail.backends.smtp.EmailBackend"
default["sentry"]["config"]["email_host"] = "localhost"
default["sentry"]["config"]["email_port"] = "25"
default["sentry"]["config"]["email_use_tls"] = false
default["sentry"]["config"]["email_subject_prefix"] = nil
default["sentry"]["config"]["email_list_namespace"] = "localhost"
default["sentry"]["config"]["email_enable_replies"] = false
default["sentry"]["config"]["additional_apps"] = ["djangosecure", "django_bcrypt"]
default["sentry"]["config"]["prepend_middleware_classes"] = ["djangosecure.middleware.SecurityMiddleware"]
default["sentry"]["config"]["append_middleware_classes"] = []
# general
default["sentry"]["config"]["use_big_ints"] = true
default["sentry"]["config"]["single_organization"] = true
default["sentry"]["config"]["debug"] = false
# Redis config
default["sentry"]["config"]["redis_enabled"] = true
default["sentry"]["config"]["redis_config"]["hosts"][0]["name"] = "default"
default["sentry"]["config"]["redis_config"]["hosts"][0]["host"] = "127.0.0.1"
default["sentry"]["config"]["redis_config"]["hosts"][0]["port"] = "6379"
# Cache config
default["sentry"]["config"]["cache"] = "sentry.cache.redis.RedisCache"
# Queue config
default["sentry"]["config"]["celery_always_eager"] = false # true will disable queue usage
default["sentry"]["config"]["broker_url"] = "redis://localhost:6379"
default["sentry"]["config"]["celeryd_concurrency"] = 1
default["sentry"]["config"]["celery_send_events"] = false
default["sentry"]["config"]["celerybeat_schedule_filename"] = "#{default["sentry"]["filestore_dir"]}/celery_beat_schedule"
#digests config
default["sentry"]["config"]["digests"] = 'sentry.digests.backends.redis.RedisBackend'
default["sentry"]["config"]["ratelimiter"] = "sentry.ratelimits.redis.RedisRateLimiter"
default["sentry"]["config"]["buffer"] = "sentry.buffer.redis.RedisBuffer"
default["sentry"]["config"]["quotas"] = "sentry.quotas.redis.RedisQuota"
default["sentry"]["config"]["tsdb"] = "sentry.tsdb.redis.RedisTSDB"
# Filestore config
default["sentry"]["config"]["filestore"] = "django.core.files.storage.FileSystemStorage"
default["sentry"]["config"]["filestore_options"]["location"] = default["sentry"]["filestore_dir"]
# data sampling
default["sentry"]["config"]["sample_data"] = false

default["sentry"]["data_bag"] = "sentry"
default["sentry"]["data_bag_item"] = "credentials"
default["sentry"]["use_encrypted_data_bag"] = false

default["sentry"]["manage_redis"] = true

# google sso
default['sentry']['google_client_id'] = false
default['sentry']['google_client_secret'] = ''
