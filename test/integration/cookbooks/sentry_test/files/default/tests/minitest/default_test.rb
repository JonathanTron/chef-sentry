require File.expand_path('../support/helpers', __FILE__)

describe 'sentry_test::default' do

  include Helpers::SentryTest

  # "id": "credentials",
  # "admin_user_name": "admin",
  # "admin_password": "admin",
  # "database_engine": "postgresql",
  # "database_name": "sentry",
  # "database_user": "sentry",
  # "database_password": "sentry",
  # "database_host": "localhost",
  # "database_port": "5432",
  # "database_options": {},
  # "signing_token": "zn49392xhsdkjLas298sd8",
  # "email_host_user": "",
  # "email_host_password": "",
  # "additional_env_vars": {}

  describe "Sentry configuration" do
    subject{ file("/opt/sentry/etc/config.py") }
    it "creates configuration" do
      subject.must_exist
    end

    # it "sets AWS_SECRET_ACCESS_KEY" do
    #   file("/etc/wal-e.d/env/AWS_SECRET_ACCESS_KEY").must_include "a_big_secret"
    # end

    # it "sets AWS_ACCESS_KEY_ID" do
    #   file("/etc/wal-e.d/env/AWS_ACCESS_KEY_ID").must_include "Eve"
    # end

    # it "sets WALE_S3_PREFIX" do
    #   file("/etc/wal-e.d/env/WALE_S3_PREFIX").must_include(
    #     "s3://postgresql-backup/#{node[:fqdn]}/wal-e"
    #   )
    # end

    # it "sets WALE_GPG_KEY_ID" do
    #   ::File.size(file("/etc/wal-e.d/env/WALE_GPG_KEY_ID").path).must_equal 0
    # end

    # it "does not set boto (Python's S3 library) default host in config" do
    #   file("/etc/boto.cfg").wont_exist
    # end

  end

end
