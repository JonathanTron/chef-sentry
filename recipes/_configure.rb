#
# Cookbook Name:: sentry
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
require 'shellwords'

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
if node["sentry"]["use_encrypted_data_bag"]
  secret = Chef::EncryptedDataBagItem.load_secret("#{node["sentry"]["data_bag_secret"]}")
  sentry_config = Chef::EncryptedDataBagItem.load(
    node["sentry"]["data_bag"],
    node["sentry"]["data_bag_item"],
    secret
  )
else
  sentry_config = data_bag_item(
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

# set env variables for runit to use
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

# redis and email configs move to conifg.yml in version 8
if node["sentry"]["version"].split(".")[0].to_i < 8
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
      admin_email: node["sentry"]["config"]["admin_email"],
      signing_token: sentry_config["signing_token"],
      public: node["sentry"]["config"]["public"],
      allow_registration: node["sentry"]["config"]["allow_registration"],
      beacon: node["sentry"]["config"]["beacon"],
      url_prefix: node["sentry"]["config"]["url_prefix"].sub(/(\/)+\z/, ""),
      web_host: node["sentry"]["config"]["web_host"],
      web_port: node["sentry"]["config"]["web_port"],
      web_options: node["sentry"]["config"]["web_options"],
      secure_proxy_ssl_header: node["sentry"]["config"]["secure_proxy_ssl_header"],
      email_default_from: node["sentry"]["config"]["email_default_from"],
      email_backend: node["sentry"]["config"]["email_backend"],
      email_host: node["sentry"]["config"]["email_host"],
      email_port: node["sentry"]["config"]["email_port"],
      email_user: sentry_config["email_host_user"],
      email_password: sentry_config["email_host_password"],
      email_use_tls: node["sentry"]["config"]["email_use_tls"],
      email_subject_prefix: node["sentry"]["config"]["email_subject_prefix"],
      additional_apps: Array(node["sentry"]["config"]["additional_apps"]),
      prepend_middleware_classes: Array(node["sentry"]["config"]["prepend_middleware_classes"]),
      append_middleware_classes: Array(node["sentry"]["config"]["append_middleware_classes"]),
      redis_enabled: node["sentry"]["config"]["redis_enabled"],
      redis_config: node["sentry"]["config"]["redis_config"],
      cache: node["sentry"]["config"]["cache"],
      celery_always_eager: node["sentry"]["config"]["celery_always_eager"],
      broker_url: node["sentry"]["config"]["broker_url"],
      celeryd_concurrency: node["sentry"]["config"]["celeryd_concurrency"],
      celery_send_events: node["sentry"]["config"]["celery_send_events"],
      celerybeat_schedule_filename: node["sentry"]["config"]["celerybeat_schedule_filename"],
      ratelimiter: node["sentry"]["config"]["ratelimiter"],
      buffer: node["sentry"]["config"]["buffer"],
      quotas: node["sentry"]["config"]["quotas"],
      tsdb: node["sentry"]["config"]["tsdb"],
      filestore: node["sentry"]["config"]["filestore"],
      filestore_options: node["sentry"]["config"]["filestore_options"],
      # google sso
      google_client_id: node['sentry']['google_client_id'],
      google_client_secret: node['sentry']['google_client_secret'],
    })
  end

  execute "sentry DB upgrade" do
    command "#{node["sentry"]["install_dir"]}/bin/sentry --config=#{node["sentry"]["config_file_path"]} upgrade --noinput"
    user sentry_user
    group sentry_group
    action :run
  end

  initial_admin_json = "#{node["sentry"]["config_dir"]}/initial_admin.json"
  initial_admin_config = {}

  initial_admin_config["first_name"] = sentry_config["admin_first_name"]
  initial_admin_config["last_name"] = sentry_config["admin_last_name"]
  create_initial_admin_command = "#{node["sentry"]["install_dir"]}/bin/sentry --config=#{node["sentry"]["config_file_path"]} loaddata #{initial_admin_json}"


  # not sure why this isn't just using the createuser command that sentry provides
  template initial_admin_json do
    source "initial_admin.json.erb"
    owner sentry_user
    group sentry_group
    mode  "0600"
    variables({
      username: sentry_config["admin_username"],
      password: sentry_config["admin_password"],
      email: sentry_config["admin_email"],
      initial_admin_config: initial_admin_config
    })
  end

  execute "create initial admin" do
    command create_initial_admin_command
    action :nothing
    subscribes :run, "template[#{initial_admin_json}]", :immediately
  end

else
  # 8.0 or above
  # this differentiates based on the version, but really this is a differentiation between
  # supporting the old way of using this cookbook and the new one written for Sentry 8.6
  template node["sentry"]["config_python_path"] do
    source "8.0/sentry.conf.py.erb"
    owner sentry_user
    group sentry_group
    mode "750"
    variables({
      # db
      db_engine: node["sentry"]["config"]["db_engine"],
      db_name: sentry_config["database_name"],
      db_user: sentry_config["database_user"],
      db_password: sentry_config["database_password"],
      db_host: sentry_config["database_host"],
      db_port: sentry_config["database_port"],
      db_options: node["sentry"]["config"]["db_options"],

      # general
      single_organization: node["sentry"]["config"]["single_organization"],
      debug: node["sentry"]["config"]["debug"],
      use_big_ints: node["sentry"]["config"]["use_big_ints"],

      # authentication
      signing_token: sentry_config["signing_token"],
      public: node["sentry"]["config"]["public"],
      allow_registration: node["sentry"]["config"]["allow_registration"],
      allow_origin: node["sentry"]["config"]["allow_origin"],
      beacon: node["sentry"]["config"]["beacon"],
      # web server
      web_host: node["sentry"]["config"]["web_host"],
      web_port: node["sentry"]["config"]["web_port"],
      web_options: node["sentry"]["config"]["web_options"],
      secure_proxy_ssl_header: node["sentry"]["config"]["secure_proxy_ssl_header"],
      force_script_name: node["sentry"]["config"]["force_script_name"],
      # smtp
      smtp_host: node["sentry"]["config"]["smtp_host"],
      smtp_port: node["sentry"]["config"]["smtp_port"],

      additional_apps: Array(node["sentry"]["config"]["additional_apps"]),
      prepend_middleware_classes: Array(node["sentry"]["config"]["prepend_middleware_classes"]),
      append_middleware_classes: Array(node["sentry"]["config"]["append_middleware_classes"]),
      cache: node["sentry"]["config"]["cache"],
      sample_data: node["sentry"]["config"]["sample_data"],
      # celery
      broker_url: node["sentry"]["config"]["broker_url"],
      # digests
      digests: node["sentry"]["config"]["digests"],
      ratelimiter: node["sentry"]["config"]["ratelimiter"],
      buffer: node["sentry"]["config"]["buffer"],
      quotas: node["sentry"]["config"]["quotas"],
      tsdb: node["sentry"]["config"]["tsdb"],
      filestore: node["sentry"]["config"]["filestore"],
      filestore_options: node["sentry"]["config"]["filestore_options"],
      # google sso
      google_client_id: node['sentry']['google_client_id'],
      google_client_secret: node['sentry']['google_client_secret'],
    })
  end

  # new config file starting in 8.0
  template node["sentry"]["config_yaml_path"] do 
    source "8.0/conf.yml.erb"
    owner sentry_user
    group sentry_group
    mode "750"
    variables({
      # email
      email_default_from: node["sentry"]["config"]["email_default_from"],
      email_host: node["sentry"]["email_host"],
      email_port: node["sentry"]["config"]["email_port"],
      email_user: sentry_config["email_host_user"],
      email_password: sentry_config["email_host_password"],
      email_use_tls: node["sentry"]["config"]["email_use_tls"],
      email_backend: node["sentry"]["config"]["email_backend"], 
      email_enable_replies: node["sentry"]["config"]["email_enable_replies"],
      email_reply_hostname: node["sentry"]["config"]["smtp_hostname"],
      mailgun_api_key: sentry_config["mailgun_api_key"],
      # redis
      redis_enabled: node["sentry"]["config"]["redis_enabled"],
      redis_config: node["sentry"]["config"]["redis_config"],
      # general configs
      admin_email: node["sentry"]["config"]["admin_email"],
      url_prefix: node["sentry"]["config"]["url_prefix"].sub(/(\/)+\z/, ""),
      # sentry secret: regen if compromised
      signing_token: sentry_config["signing_token"]
    })
  end

  # per the 8.x docs
  execute "sentry DB upgrade" do
    command "SENTRY_CONF=#{node['sentry']['config_dir']} #{node["sentry"]["install_dir"]}/bin/sentry upgrade --noinput"
    user sentry_user
    group sentry_group
    action :run
  end

  # EXPLICIT GUARD: if this is not the first run and a user already exists, trying to create a user errors
  email = sentry_config['admin_email']
  password = sentry_config['admin_password']
  check_user_command = "echo 'from sentry.models import User; import sys; exit_code = 0 if User.objects.filter(email=\"#{email}\").exists() else 1; sys.exit(exit_code);' | SENTRY_CONF=#{node['sentry']['config_dir']} #{node['sentry']['install_dir']}/bin/sentry shell"
  execute 'create sentry user' do
    command "SENTRY_CONF=#{node['sentry']['config_dir']} #{node['sentry']['install_dir']}/bin/sentry createuser --email #{email.shellescape} --password #{password.shellescape} --superuser"
    not_if check_user_command
  end

end
