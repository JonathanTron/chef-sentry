#
# Cookbook Name:: wal-e
# Recipe:: _configure
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

Erubis::Context.send(:include, Extensions::Templates)

sentry_user = node["sentry"]["user"]
sentry_group = node["sentry"]["group"]

# Prepare envdir for sentry configs
directory node["sentry"]["env_d_path"] do
  owner "root"
  group sentry_group
  mode "750"
  action :create
end

sentry_env_path = node["sentry"]["env_path"]
sentry_config = if node["sentry"]["use_encrypted_data_bag"]
  Chef::EncryptedDataBagItem.load(
    node["sentry"]["data_bag"],
    node["sentry"]["data_bag_item"]
  )
else
  data_bag_item(
    node["sentry"]["data_bag"],
    node["sentry"]["data_bag_item"]
  )
end

Chef::Application.fatal!(
  "Could not find " +
  "item: #{node["sentry"]["data_bag_item"]} " +
  "in databag #{node["sentry"]["data_bag"]}"
) unless sentry_config

directory sentry_env_path do
  owner "root"
  group sentry_group
  mode "750"
  action :create
end

(sentry_config["additional_env_vars"] || {}).each do |key, value|

  file "#{sentry_env_path}/#{key.to_s.upcase}" do
    owner "root"
    group sentry_group
    mode "750"
    action :create
    content value
  end

end

# Prepare sentry config directory
directory node["sentry"]["config_dir"] do
  owner sentry_user
  group sentry_group
  mode "750"
  action :create
end

template node["sentry"]["config_file_path"] do
  source "sentry.conf.py.erb"
  owner sentry_user
  group sentry_group
  mode "750"
  variables({
    db_engine: node["sentry"]["config"]["db_engine"],
    db_name: sentry_config["database_name"],
    db_user: sentry_config["database_user"],
    db_password: sentry_config["database_password"],
    db_host: sentry_config["database_host"],
    db_port: sentry_config["database_port"],
    db_options: node["sentry"]["config"]["db_options"],
    signing_token: sentry_config["signing_token"],
    public: node["sentry"]["config"]["public"],
    allow_registration: node["sentry"]["config"]["allow_registration"],
    url_prefix: node["sentry"]["config"]["url_prefix"].sub(/(\/)+\z/, ""),
    web_host: node["sentry"]["config"]["web_host"],
    web_port: node["sentry"]["config"]["web_port"],
    web_options: node["sentry"]["config"]["web_options"],
    email_default_from: node["sentry"]["config"]["email_default_from"],
    email_backend: node["sentry"]["config"]["email_backend"],
    email_host: node["sentry"]["config"]["email_host"],
    email_port: node["sentry"]["config"]["email_port"],
    email_user: sentry_config["email_host_user"],
    email_password: sentry_config["email_port_port"],
    email_use_tls: node["sentry"]["config"]["email_use_tls"],
    email_subject_prefix: node["sentry"]["config"]["email_subject_prefix"],
    additional_apps: Array(node["sentry"]["config"]["additional_apps"]),
    prepend_middleware_classes: Array(node["sentry"]["config"]["prepend_middleware_classes"]),
    append_middleware_classes: Array(node["sentry"]["config"]["append_middleware_classes"]),
  })
end

execute "sentry DB upgrade" do
  command "#{node["sentry"]["install_dir"]}/bin/sentry --config=#{node["sentry"]["config_file_path"]} upgrade --noinput"
  user sentry_user
  group sentry_group
  action :run
end

initial_admin_json = "#{node["sentry"]["config_dir"]}/initial_admin.json"
template initial_admin_json do
  source "initial_admin.json.erb"
  owner sentry_user
  group sentry_group
  mode  "0600"
  variables({
    username: sentry_config["admin_username"],
    password: sentry_config["admin_password"],
    email: sentry_config["admin_email"]
  })
end

execute "create initial admin" do
  command "#{node["sentry"]["install_dir"]}/bin/sentry --config=#{node["sentry"]["config_file_path"]} loaddata #{initial_admin_json}"
  action :nothing
  subscribes :run, "template[#{initial_admin_json}]", :immediately
end
