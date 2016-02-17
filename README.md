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

| Key | Type | Description | Default |
|-----|------|-------------|---------|
| `['sentry']['version']` | String | which version to install | `"7.7.1" **` |
| `['sentry']['pipname']` | String | which package to install | `"sentry[postgres]"` |
| `['sentry']['plugins']` | Array | list of plugins to install: ``` [ "sentry-irc", # No version specified ["sentry-github", "0.1.2"], # With explicit version specified ] ``` | `[["django-secure", "1.0.1"], ["django-bcrypt", "0.9.2"], ["django-sendmail-backend", "0.1.2"]]` |
| `["dependency"]["packages"]` | Array | list of packages to install | `["libxml2-dev", "libxslt1-dev", "libffi-dev",]` |
| `['sentry']['user']` | String | system user to run sentry | `"sentry"` |
| `['sentry']['group']` | String | system group to run sentry | `"sentry"` |
| `['sentry']['install_dir']` | String | full path to the sentry install directory | `"/opt/sentry/"` |
| `['sentry']['filestore_dir']` | String | full path to the sentry filestore directory | `"/opt/sentry/data"` |
| `['sentry']['config_dir']` | String | path to sentry config directory | `"/opt/sentry/etc"` |
| `['sentry']['config_file_path']` | String | path to sentry config file | `"/opt/sentry/etc/config.py"` |
| `['sentry']['env_d_path']` | String | path to the daemontool's env.d path for sentry configurations | `"/etc/sentry.d"` |
| `['sentry']['env_path']` | String | path to the daemontool's env path for sentry configurations | `"/etc/sentry.d/env"` |
| `['sentry']['config']['url_prefix']` | String | URL where sentry will be accessible | `"http://localhost"` |
| `['sentry']['config']['db_engine']` | String | Django class to use to connect to database | `"django.db.backends.postgresql_psycopg2"` |
| `['sentry']['config']['db_options']` | Hash | OPTIONS passed to database config | `{autocommit: true}` |
| `['sentry']['config']['web_host']` | String | IP to which sentry is listening | `"127.0.0.1"` |
| `['sentry']['config']['web_port']` | String | Port to which sentry is listening | `9000` |
| `['sentry']['config']['web_options']` | Hash | additional options used in SENTRY_WEB_OPTIONS | `{"workers": 3, secure_scheme_headers: {"X-FORWARDED-PROTO": 'https'}}` |
| `['sentry']['config']['additional_apps']` | Array | additional apps to append to INSTALLED_APPS | `["djangosecure", "django_bcrypt"]` |
| `['sentry']['config']['prepend_middleware_classes']` | Array | additional middlewares classes to prepend to MIDDLEWARE_CLASSES | `["djangosecure.middleware.SecurityMiddleware"]` |
| `['sentry']['config']['append_middleware_classes']` | Array | additional middlewares classes to append to MIDDLEWARE_CLASSES | `[]` |
| `['sentry']['config']['email_default_from']` | String | email address used in from of sent emails | `"#{node["sentry"]["user"]}@#{node[:fqdn]}"` |
| `['sentry']['config']['email_backend']` | String | EMAIL_BACKEND class to use by django | `"django.core.mail.backends.smtp.EmailBackend"` |
| `['sentry']['config']['email_host']` | String | SMTP host to use | `"localhost"` |
| `['sentry']['config']['email_port']` | String | SMTP port to use | `25` |
| `['sentry']['config']['email_use_tls']` | Boolean | Set wether to use tls for auth | `false` |
| `['sentry']['config']['email_subject_prefix']` | String | Prefix for sent emails | `nil` |
| `['sentry']['data_bag']` | String | name of the data_bag holding the sentry configuration | `"sentry"` |
| `['sentry']['data_bag_item']` | String | name of the data_bag's item holding the credentials | `"credentials"` |
| `['sentry']['use_encrypted_data_bag']` | Boolean | if the data_bag is expected to be encrypted or not | `false` |
| `['sentry']['data_bag_secret']` | String | Path to the databag secret file when using an encrypted databag, if nil the value from `Chef::Config[:encrypted_data_bag_secret]` is used. | `nil` |

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
