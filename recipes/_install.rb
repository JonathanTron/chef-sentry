#
# Cookbook Name:: sentry
# Recipe:: _install
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

if node["sentry"]["manage_redis"]
  include_recipe "sentry::_redis"
end

include_recipe "poise-python"

sentry_user = node["sentry"]["user"]
sentry_group = node["sentry"]["group"]

group sentry_group

user sentry_user do
  group sentry_group
  home node["sentry"]["install_dir"]
  action [:create, :manage]
end

directory node["sentry"]["install_dir"] do
  owner sentry_user
  group sentry_group
  recursive true
end

directory node["sentry"]["filestore_dir"] do
  owner sentry_user
  group sentry_group
  recursive true
end

# Prepare sentry config directory
directory node["sentry"]["config_dir"] do
  owner sentry_user
  group sentry_group
  mode "750"
  action :create
  recursive true
end

# Create a virtualenv for sentry
python_virtualenv node["sentry"]["install_dir"] do
  user sentry_user
  group sentry_group
  action :create
end

# Install deps packages to build sentry's deps
node["sentry"]["dependency"]["packages"].each do |name|
  package name
end

# Install sentry via pip in virtualenv
python_package node["sentry"]["pipname"] do
  virtualenv node["sentry"]["install_dir"]
  version node["sentry"]["version"]
  user sentry_user
  group sentry_group
end

# Install database pip dependency
node["sentry"]["database"]["pipdeps"].each do |dep|
  dep_name, dep_version = dep

  python_package dep_name do
    virtualenv node["sentry"]["install_dir"]
    version dep_version
    user sentry_user
    group sentry_group
  end
end

# Install additional plugins via pip in virtualenv
node["sentry"]["plugins"].each do |plugin|
  plugin_name, plugin_version = plugin

  python_package plugin_name do
    virtualenv node["sentry"]["install_dir"]
    version plugin_version
    user sentry_user
    group sentry_group
  end
end
