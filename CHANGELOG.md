# CHANGELOG for sentry

This file is used to list changes made in each version of sentry.

## dev

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
