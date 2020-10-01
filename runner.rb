# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'faraday'
require 'json'

require_relative 'lib/compressor'
require_relative 'lib/yandex_disk'

ENV['ACCESS_TOKEN'] ||= '***'

yandex_disk = YandexDisk.new(ENV['ACCESS_TOKEN'])
compressor = Compressor.new

begin
  local_archive = compressor.prepare('~/Dropbox/dotFiles')
  yandex_disk.create_folder!('backups')
  yandex_disk.upload(local_archive, 'backups')
ensure
  compressor.cleanup!
end
