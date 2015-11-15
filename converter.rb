!#/bin/ruby

require 'rubygems'
require 'bundler/setup'

require 'json'
require 'csv'
require 'google_drive'
require 'launchy'

require 'pry'

require 'dotenv'
Dotenv.load

require './extensions'
require './json2csv'
require './cloud_sync'

def main
  csv_file = Json2Csv.new('./data/*').convert
  client = CloudSync.new
  client.upload_to_drive(csv_file)
end

main
