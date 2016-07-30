#
# Cookbook Name:: sentry
# Recipe:: _service
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

include_recipe "runit"

subscribes_resources = [
   "template[#{node["sentry"]["config_file_path"]}]",
   "python_pip[#{node["sentry"]["pipname"]}]"
 ] +
   node["sentry"]["database"]["pipdeps"].map do |dep|
     dep_name, _ = dep
     "python_pip[#{dep_name}]"
   end +
   node["sentry"]["plugins"].map do |plugin|
     plugin_name, _ = plugin
     "python_pip[#{plugin_name}]"
   end

# sentry 'start' and 'celery' were deprecated in 8.0 in favor of
# sentry 'run < web/worker/cron >'
if node['sentry']['version'] .split('.')[0].to_i >= 8

  runit_service "sentry-web" do
    options({
      virtualenv_activate: "#{node["sentry"]["install_dir"]}/bin/activate",
      env_path: "#{node['sentry']['env_path']}",
      user: node["sentry"]["user"],
      group: node["sentry"]["group"],
      sentry_cmd: "#{node["sentry"]["install_dir"]}/bin/sentry"
    })
    sv_timeout 180
    retries 2
    retry_delay 5
    action [:enable, :start]
    subscribes_resources.each do |res|
      subscribes :restart, res, :delayed
    end
  end

  runit_service "sentry-worker" do
    options({
      virtualenv_activate: "#{node["sentry"]["install_dir"]}/bin/activate",
      env_path: "#{node['sentry']['env_path']}",
      user: node["sentry"]["user"],
      group: node["sentry"]["group"],
      sentry_cmd: "#{node["sentry"]["install_dir"]}/bin/sentry"
    })
    sv_timeout 10
    retries 2
    retry_delay 5
    action [:enable, :start]
    subscribes_resources.each do |res|
      subscribes :restart, res, :delayed
    end
  end

  runit_service "sentry-cron" do
    options({
      virtualenv_activate: "#{node["sentry"]["install_dir"]}/bin/activate",
      env_path: "#{node['sentry']['env_path']}",
      user: node["sentry"]["user"],
      group: node["sentry"]["group"],
      sentry_cmd: "#{node["sentry"]["install_dir"]}/bin/sentry"
    })
    sv_timeout 10
    retries 2
    retry_delay 5
    action [:enable, :start]
    subscribes_resources.each do |res|
      subscribes :restart, res, :delayed
    end
  end
else # using sentry commands: 'start' & 'celery'
  runit_service "sentry" do
    options({
      virtualenv_activate: "#{node["sentry"]["install_dir"]}/bin/activate",
      user: node["sentry"]["user"],
      group: node["sentry"]["group"],
      env_path: node["sentry"]["env_path"],
      sentry_cmd: "#{node["sentry"]["install_dir"]}/bin/sentry",
      config_path: node["sentry"]["config_file_path"],
    })
    retries 2
    retry_delay 5
    action [:enable, :start]
    subscribes_resources.each do |res|
      subscribes :restart, res, :delayed
    end
  end
  
  runit_service "sentry_queue" do
    options({
      virtualenv_activate: "#{node["sentry"]["install_dir"]}/bin/activate",
      user: node["sentry"]["user"],
      group: node["sentry"]["group"],
      env_path: node["sentry"]["env_path"],
      sentry_cmd: "#{node["sentry"]["install_dir"]}/bin/sentry",
      config_path: node["sentry"]["config_file_path"],
    })
    retries 2
    retry_delay 5
    action [:enable, :start]
    subscribes_resources.each do |res|
      subscribes :restart, res, :delayed
    end
  end

end
