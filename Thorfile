# encoding: utf-8

require 'bundler'
require 'bundler/setup'
require 'thor/foodcritic'
require 'berkshelf/thor'

class Secret < Thor

  desc "edit DATA_BAG ITEM_NAME", "Edit an encrypted data bag item in $EDITOR"
  def edit(data_bag, item_name)
    check_editor_defined!

    unless data_bag && item_name
      abort 'usage: thor secret:edit data_bag item_name'
    end

    keyfile = File.expand_path "../test/data_bag_secret", __FILE__
    encrypted_path = "test/integration/data_bags/#{data_bag}/#{item_name}.json"
    edit_encrypted_data_bag data_bag, item_name, keyfile, encrypted_path
  end

  private

  def edit_encrypted_data_bag(data_bag, item_name, keyfile, encrypted_path)
    require "chef/encrypted_data_bag_item"
    require "json"
    require "tempfile"

    abort "Cannot find #{File.join(Dir.pwd, encrypted_path)}" unless File.exists? encrypted_path
    abort "The secret key must be located in #{keyfile}" unless File.exists? keyfile

    secret = Chef::EncryptedDataBagItem.load_secret keyfile

    decrypted_file = Tempfile.new ["#{data_bag}_#{item_name}",".json"]
    at_exit { decrypted_file.delete }

    encrypted_data = JSON.parse File.read encrypted_path
    plain_data = Chef::EncryptedDataBagItem.new(encrypted_data, secret).to_hash

    decrypted_file.puts JSON.pretty_generate(plain_data)
    decrypted_file.close

    system "#{ENV['EDITOR']} #{decrypted_file.path}"

    plain_data = JSON.parse File.read decrypted_file.path
    encrypted_data = Chef::EncryptedDataBagItem.encrypt_data_bag_item plain_data, secret

    File.write encrypted_path, JSON.pretty_generate(encrypted_data)
  end

  def check_editor_defined!
    unless ENV['EDITOR']
      puts "No EDITOR found. Try:"
      puts "export EDITOR=vim"
      exit 1
    end
  end

end
