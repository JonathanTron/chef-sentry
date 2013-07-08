require File.expand_path('../support/helpers', __FILE__)

describe 'wal-e_test::s3_host' do

  include Helpers::WalETest

  describe "S3 configurations" do
    it "sets AWS_SECRET_ACCESS_KEY" do
      file("/etc/wal-e.d/env/AWS_SECRET_ACCESS_KEY").must_include "a_big_secret"
    end

    it "sets AWS_ACCESS_KEY_ID" do
      file("/etc/wal-e.d/env/AWS_ACCESS_KEY_ID").must_include "Eve"
    end

    it "sets WALE_S3_PREFIX" do
      file("/etc/wal-e.d/env/WALE_S3_PREFIX").must_include(
        "s3://postgresql-backup/#{node[:fqdn]}/wal-e"
      )
    end

    it "sets WALE_GPG_KEY_ID" do
      ::File.size(file("/etc/wal-e.d/env/WALE_GPG_KEY_ID").path).must_equal 0
    end

    it "sets boto (Python's S3 library) default host in config" do
      file("/etc/boto.cfg").must_include(
        "[s3]\nhost=s3-eu-west-1.amazonaws.com"
      )
    end

  end

end
