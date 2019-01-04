# CHANGELOG for sentry

This file is used to list changes made in each version of sentry.

## 0.5.0 (2018-06-18)

* Updating Sentry to the lastest version [@oscar123mendoza](https://github.com/oscar123mendoza)
* Revoving old data bag syntax [#24](https://github.com/JonathanTron/chef-sentry/pull/26)

## 0.4.5 (2018-06-18)

* Fixed the GITHUB_API_SECRET parameter. (Nilanjan Roy) 
  [#24](https://github.com/JonathanTron/chef-sentry/pull/24)
* Added required configuration while using reverse proxy. (Nilanjan Roy)
  [#25](https://github.com/JonathanTron/chef-sentry/pull/25)

## 0.4.4 (2017-09-29)

* Allow configuration of sentry-plugins SSOs

## 0.4.3 (2017-09-28)

* Ensure SENTRY_CONF is set in runit env

## 0.4.2 (2017-09-28)

* Remove django-secure as it's imcompatible with latest django

## 0.4.1 (2017-09-28)

* Fix a bug when using encrypted data bags and `node["sentry"]["data_bag_secret"]`
  is not set.

## 0.4.0 (2017-09-28)

* Update Sentry to 8.20.0

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
