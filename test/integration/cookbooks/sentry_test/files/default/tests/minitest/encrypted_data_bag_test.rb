require File.expand_path('../support/helpers', __FILE__)

describe 'sentry_test::encrypted_data_bag_test' do

  include Helpers::SentryTest

  describe "Sentry configuration" do
    subject{ file("/opt/sentry/etc/config.py") }

    it "is created" do
      subject.must_exist
    end

    it "is owned by sentry user" do
      subject.must_have(:owner, node["sentry"]["user"])
    end

    it "is owned by sentry group" do
      subject.must_have(:group, node["sentry"]["group"])
    end

    it "sets database engine based on node config" do
      subject.must_include "'ENGINE': 'django.db.backends.postgresql_psycopg2',"
    end

    it "sets database name based on data bag" do
      subject.must_include "'NAME': 'sentry',"
    end

    it "sets database user based on data bag" do
      subject.must_include "'USER': 'sentry',"
    end

    it "sets database password based on data bag" do
      subject.must_include "'PASSWORD': 'sentry',"
    end

    it "sets database host based on data bag" do
      subject.must_include "'HOST': 'localhost',"
    end

    it "sets database port based on data bag" do
      subject.must_include "'PORT': '5432',"
    end

    it "sets database options based on node config" do
      subject.must_include "'OPTIONS': {'autocommit': True}"
    end

    it "sets signing token based on data bag" do
      subject.must_include "SENTRY_KEY = 'nxlhsoiALKS21wsjdjs010203948KDJSkakalkasjd02'"
    end

    it "sets sentry url prefix based on node config" do
      subject.must_include "SENTRY_URL_PREFIX = 'http://localhost:9000'"
    end

    it "sets sentry defaut from for email based on node config" do
      subject.must_include "SENTRY_SERVER_EMAIL = '#{node["sentry"]["config"]["email_default_from"]}'"
    end
  end

  it "starts sentry service" do
    service("sentry").must_be_running
  end

end
