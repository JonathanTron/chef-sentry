# CHANGELOG for sentry

This file is used to list changes made in each version of sentry.

## 0.3.2 (2017-05-26)

* Construct `default["sentry"]["config"]["celerybeat_schedule_filename"]` and
  `default["sentry"]["config"]["filestore_options"]["location"]` from
  `node["sentry"]["filestore_dir"]` (Luka Lüdicke)
  [#21](https://github.com/JonathanTron/chef-sentry/pull/21)
* Update File storage setting for Sentry 8.10 compatibility (Luka Lüdicke)
  [#20](https://github.com/JonathanTron/chef-sentry/pull/20)
  [#17](https://github.com/JonathanTron/chef-sentry/issues/17)

## 0.3.1 (2017-01-02)

* Ensure parent install directory is created too (Nilanjan Roy)
  [#14](https://github.com/JonathanTron/chef-sentry/issues/14)
* Depends on `poise-python` cookbook instead of `python` (Nilanjan Roy)
  [#15](https://github.com/JonathanTron/chef-sentry/pull/15)

## 0.3.0 (2016-08-14)

* Default to Sentry 8.6.0
* Add Sentry 8.6 support (Matt Leick)
  [#9](https://github.com/JonathanTron/chef-sentry/pull/9)

## 0.2.2 (2016-02-17)

* Add support for Sentry 8.x
* Bump default version to 7.7.1

## 0.2.1 (2015-05-09)

* Update `default["sentry"]["config"]["redis_enabled"]` to true

## 0.2.0 (2015-05-09)

* Upgrade Sentry to 7.4.3
* Add a lot more configuration to allow buffers, queues, rate limits, quotas and
  TSDB.

## 0.1.2 (2014-06-30)

* Ensure `runit_service[sentry]` is not restarted during each Chef run:
  * Don't use `sentry[postgres]` meta-package as it leaves `python_pip` LWRP
  unable to detect it's already installed.
  * Add `default['sentry']['database']['pipdeps']` with a default to install
  `psycopg2==2.4.6`.
  * Add versions to `default['sentry']['plugins']` to ensure no re-install when
  not needed: `django-secure==1.0`, `django-bcrypt==0.9.2`, `django-sendmail-backend==0.1.2`

## 0.1.1 (2014-06-06)

* Upgrade Sentry to 5.4.6

## 0.1.0  (2013-07-09)

* Initial release of sentry
