#!/usr/bin/env ruby

require 'fileutils'
require 'flickraw'
require 'mechanize'
require 'thor'
require './flickr_config'
require './flickr_backup'

class Downloader < Thor
  desc 'download_profile', "Download Your Flickr portfolio."
  method_option :input_file, desc: 'Import url list from file', default: nil
  method_option :output_file, desc: 'Export url list to file', default: nil
  method_option :directory, desc: 'Directory to save pictures', default: "#{ENV['HOME']}/Pictures/Flickr"
  def download_profile
    FlickrConfig.setup_flickr
    fail unless FlickrConfig.credential_check(flickr)

    backup = FlickrBackup.new(options[:directory], flickr)
    backup.start
  end
end

Downloader.start
