# CHANGELOG for sentry

This file is used to list changes made in each version of sentry.

## 0.2.0:

* Upgrade Sentry to 7.4.3
* Add a lot more configuration to allow buffers, queues, rate limits, quotas and
  TSDB.

## 0.1.2:

* Ensure `runit_service[sentry]` is not restarted during each Chef run:
  * Don't use `sentry[postgres]` meta-package as it leaves `python_pip` LWRP
  unable to detect it's already installed.
  * Add `default['sentry']['database']['pipdeps']` with a default to install
  `psycopg2==2.4.6`.
  * Add versions to `default['sentry']['plugins']` to ensure no re-install when
  not needed: `django-secure==1.0`, `django-bcrypt==0.9.2`, `django-sendmail-backend==0.1.2`

## 0.1.1:

* Upgrade Sentry to 5.4.6

## 0.1.0:

* Initial release of sentry
