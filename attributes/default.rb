#
# Cookbook Name:: wal-e
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

default["sentry"]["version"] = "5.4.5"
default["sentry"]["pipname"] = "sentry[postgres]"
default["sentry"]["plugins"] = []

default["sentry"]["install_dir"] = "/opt/sentry"
default["sentry"]["config_dir"] = "#{node["sentry"]["install_dir"]}/etc"
default["sentry"]["config_file_path"] = "#{node["sentry"]["config_dir"]}/config.py"

default["sentry"]["env_d_path"] = "/etc/sentry.d"
default["sentry"]["env_path"] = "#{node["sentry"]["env_d_path"]}/env"

default["sentry"]["config"]["url_prefix"] = "http://localhost"
default["sentry"]["config"]["web_host"] = "0.0.0.0"
default["sentry"]["config"]["web_port"] = 9000
default["sentry"]["config"]["web_options"] = {
  "workers" => 3,
  "secure_scheme_headers" => {
    "X-FORWARDED-PROTO" => "https"
  }
}
default["sentry"]["config"]["email_host"] = "localhost"
default["sentry"]["config"]["email_port"] = "25"
default["sentry"]["config"]["email_use_tls"] = false

default["sentry"]["data_bag"] = "sentry"
default["sentry"]["data_bag_item"] = "credentials"
default["sentry"]["use_encrypted_data_bag"] = false
