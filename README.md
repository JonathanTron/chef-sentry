sentry Cookbook
=================

Installs and configure Sentry realtime error logging and aggregation platform. This cookbook supports sentry 7.7.1 and above.

Requirements
------------

#### platforms
- `ubuntu` - sentry has only been tested on ubuntu

#### cookbooks
- `python` - for `python`, `virtualenv` and `pip` installation and LWRP.

Attributes
----------

#### sentry::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['sentry']['version']</tt></td>
    <td>String</td>
    <td>which version to install</td>
    <td><tt>"7.7.1" **</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['pipname']</tt></td>
    <td>String</td>
    <td>which package to install</td>
    <td><tt>"sentry[postgres]"</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['plugins']</tt></td>
    <td>Array</td>
    <td>
      list of plugins to install:
      ```
      [
        "sentry-irc",                 # No version specified
        ["sentry-github", "0.1.2"], # With explicit version specified
      ]
      ```
    </td>
    <td><tt>[["django-secure", "1.0.1"], ["django-bcrypt", "0.9.2"], ["django-sendmail-backend", "0.1.2"]]</tt></td>
  </tr>
  <tr>
    <td><tt>["dependency"]["packages"]</tt></td>
    <td>Array</td>
    <td>list of packages to install</td>
    <td><tt>["libxml2-dev", "libxslt1-dev", "libffi-dev",]</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['user']</tt></td>
    <td>String</td>
    <td>system user to run sentry</td>
    <td><tt>"sentry"</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['group']</tt></td>
    <td>String</td>
    <td>system group to run sentry</td>
    <td><tt>"sentry"</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['install_dir']</tt></td>
    <td>String</td>
    <td>full path to the sentry install directory</td>
    <td><tt>"/opt/sentry/"</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['filestore_dir']</tt></td>
    <td>String</td>
    <td>full path to the sentry filestore directory</td>
    <td><tt>"/opt/sentry/data"</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['config_dir']</tt></td>
    <td>String</td>
    <td>path to sentry config directory</td>
    <td><tt>"/opt/sentry/etc"</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['config_file_path']</tt></td>
    <td>String</td>
    <td>path to sentry config file</td>
    <td><tt>"/opt/sentry/etc/config.py"</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['env_d_path']</tt></td>
    <td>String</td>
    <td>path to the daemontool's env.d path for sentry configurations</td>
    <td><tt>"/etc/sentry.d"</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['env_path']</tt></td>
    <td>String</td>
    <td>path to the daemontool's env path for sentry configurations</td>
    <td><tt>"/etc/sentry.d/env"</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['config']['url_prefix']</tt></td>
    <td>String</td>
    <td>URL where sentry will be accessible</td>
    <td><tt>"http://localhost"</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['config']['db_engine']</tt></td>
    <td>String</td>
    <td>Django class to use to connect to database</td>
    <td><tt>"django.db.backends.postgresql_psycopg2"</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['config']['db_options']</tt></td>
    <td>Hash</td>
    <td>OPTIONS passed to database config</td>
    <td><tt>{autocommit: true}</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['config']['web_host']</tt></td>
    <td>String</td>
    <td>IP to which sentry is listening</td>
    <td><tt>"127.0.0.1"</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['config']['web_port']</tt></td>
    <td>String</td>
    <td>Port to which sentry is listening</td>
    <td><tt>9000</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['config']['web_options']</tt></td>
    <td>Hash</td>
    <td>additional options used in SENTRY_WEB_OPTIONS</td>
    <td><tt>{"workers": 3, secure_scheme_headers: {"X-FORWARDED-PROTO": 'https'}}</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['config']['additional_apps']</tt></td>
    <td>Array</td>
    <td>additional apps to append to INSTALLED_APPS</td>
    <td><tt>["djangosecure", "django_bcrypt"]</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['config']['prepend_middleware_classes']</tt></td>
    <td>Array</td>
    <td>additional middlewares classes to prepend to MIDDLEWARE_CLASSES</td>
    <td><tt>["djangosecure.middleware.SecurityMiddleware"]</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['config']['append_middleware_classes']</tt></td>
    <td>Array</td>
    <td>additional middlewares classes to append to MIDDLEWARE_CLASSES</td>
    <td><tt>[]</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['config']['email_default_from']</tt></td>
    <td>String</td>
    <td>email address used in from of sent emails</td>
    <td><tt>"#{node["sentry"]["user"]}@#{node[:fqdn]}"</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['config']['email_backend']</tt></td>
    <td>String</td>
    <td>EMAIL_BACKEND class to use by django</td>
    <td><tt>"django.core.mail.backends.smtp.EmailBackend"</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['config']['email_host']</tt></td>
    <td>String</td>
    <td>SMTP host to use</td>
    <td><tt>"localhost"</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['config']['email_port']</tt></td>
    <td>String</td>
    <td>SMTP port to use</td>
    <td><tt>25</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['config']['email_use_tls']</tt></td>
    <td>Boolean</td>
    <td>Set wether to use tls for auth</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['config']['email_subject_prefix']</tt></td>
    <td>String</td>
    <td>Prefix for sent emails</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['data_bag']</tt></td>
    <td>String</td>
    <td>name of the data_bag holding the sentry configuration</td>
    <td><tt>"sentry"</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['data_bag_item']</tt></td>
    <td>String</td>
    <td>name of the data_bag's item holding the credentials</td>
    <td><tt>"credentials"</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['use_encrypted_data_bag']</tt></td>
    <td>Boolean</td>
    <td>if the data_bag is expected to be encrypted or not</td>
    <td><tt>false</tt></td>
  </tr>
  <tr>
    <td><tt>['sentry']['data_bag_secret']</tt></td>
    <td>String</td>
    <td>Path to the databag secret file when using an encrypted databag, if nil the value from `Chef::Config[:encrypted_data_bag_secret]` is used.</td>
    <td><tt>nil</tt></td>
  </tr>
</table>


****NOTE** Versions prior to 7.7.x are having trouble running sentry upgrade command. It throws below error:

	STDERR: FATAL ERROR - The following SQL query failed: ALTER TABLE "sentry_authprovider" ALTER COLUMN "config" TYPE jsonb, ALTER COLUMN 	"config" DROP NOT NULL, ALTER COLUMN "config" DROP DEFAULT; The error was: column "config" cannot be cast automatically to type jsonb HINT: 	You might need to specify "USING config::jsonb".

Usage
-----

#### Sentry credentials

Store the default admin account informations as well as the database connection
information.

Here's the expected content of such a `data_bag item`:

```json
{
  "id": "credentials",
  "admin_username": "xxxxxxx",
  "admin_password": "xxxxxxx",
  "admin_first_name": "Chef",
  "admin_last_name": "Admin",
  "admin_email": "xxxxxxx",
  "database_name": "sentry",
  "database_user": "sentry",
  "database_password": "xxxxxx",
  "database_host": "",
  "database_port": "",
  "signing_token": "xxxxxxx",
  "email_host_user": "xxxxxxx",
  "email_host_password": "xxxxxxx",
  "additional_env_vars": {}
}
```

#### To install and configure sentry

Include `sentry` or more explictly `sentry::default` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[sentry::default]"
  ]
}
```

Upgrade info
------------

If you come from older version < 6.4.x then you need to run the following SQL query on the database, before upgrading:

```
UPDATE sentry_project SET team_id=(SELECT id FROM sentry_team LIMIT 1) WHERE team_id IS null;
```

If you used `bcrypt` for passwords, then you run the following SQL query on the database:

```
UPDATE auth_user SET password=CONCAT('bcrypt', SUBSTR(password, 3)) WHERE password LIKE 'bc$%';
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------

Author:: Jonathan Tron (<jonathan@openhood.com>)

Copyright 2013, Openhood S.E.N.C.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
