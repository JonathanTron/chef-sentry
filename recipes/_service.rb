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

runit_service "sentry" do
  options({
    virtualenv_activate: "#{node["sentry"]["install_dir"]}/bin/activate",
    user: node["sentry"]["user"],
    group: node["sentry"]["group"],
    env_path: node["sentry"]["env_path"],
    sentry_cmd: "#{node["sentry"]["install_dir"]}/bin/sentry",
    config_path: node["sentry"]["config_file_path"],
  })
  action [:enable, :start]
end
