#
# Cookbook Name:: sentry_test
# Recipe:: encrypted_data_bag
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

include_recipe "apt"

node.override["postgresql"]["password"]["postgres"] = "test"

include_recipe "postgresql::client"
include_recipe "postgresql::ruby" # So that postgresql tests pass...
include_recipe "postgresql::server"

package "postfix"
node.override["sentry"]["config"]["email_default_from"] = "sentry@example.com"
node.override["sentry"]["data_bag_item"] = "sentry_encrypted"
node.override["sentry"]["use_encrypted_data_bag"] = true

bash "create-sentry-role" do
  user "postgres"
  code <<-EOH
echo "CREATE ROLE sentry LOGIN ENCRYPTED PASSWORD 'sentry';" | psql
  EOH
  action :run
  not_if "psql -At -F ' ' -c '\du' | egrep --quiet '^sentry '", user: "postgres"
end

bash "create-sentry-database" do
  user "postgres"
  code <<-EOH
createdb -E UTF-8 -O sentry sentry
  EOH
  action :run
  not_if "psql -At -F ' ' -l | egrep --quiet '^sentry '", user: "postgres"
end

include_recipe "sentry::default"
