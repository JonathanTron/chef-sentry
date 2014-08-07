#
# Cookbook Name:: wal-e
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

include_recipe "python"

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
end

# Create a virtualenv for sentry
python_virtualenv node["sentry"]["install_dir"] do
  owner sentry_user
  group sentry_group
  action :create
end

# Install sentry via pip in virtualenv
%w(libxml2-dev libxslt-dev).each do |pkg|
  package pkg do
    action :install
  end
end

# Because python_pip doesn't support adding arguments yet we have to do this 
# the hard way
# See: https://github.com/poise/python/issues/98
pip_cmd = "#{node['sentry']['install_dir']}/bin/pip"
pkg_name = node['sentry']['pipname']
pkg_ver = node['sentry']['version']

execute 'pip install sentry' do
  command "#{pip_cmd} install --allow-external #{pkg_name} --allow-unverified #{pkg_name} #{pkg_name}==#{pkg_ver}"
end

#python_pip node["sentry"]["pipname"] do
#  virtualenv node["sentry"]["install_dir"]
#  version node["sentry"]["version"]
#  user sentry_user
#  group sentry_group
#end

# Install database pip dependency
node["sentry"]["database"]["pipdeps"].each do |dep|
  dep_name, dep_version = dep

  python_pip dep_name do
    virtualenv node["sentry"]["install_dir"]
    version dep_version
    user sentry_user
    group sentry_group
  end
end

# Install additional plugins via pip in virtualenv
node["sentry"]["plugins"].each do |plugin|
  plugin_name, plugin_version = plugin

  python_pip plugin_name do
    virtualenv node["sentry"]["install_dir"]
    version plugin_version
    user sentry_user
    group sentry_group
  end
end
