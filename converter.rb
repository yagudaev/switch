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
require './csv2json'
require './cloud_sync'

def main
  command = ARGV[0]

  case command
  when "json2csv"
    csv_file = Json2Csv.new('./data/*').convert
    client = CloudSync.new
    client.upload_to_drive(csv_file)
  when "csv2json"
    client = CloudSync.new
    client.download_from_drive(FILE_NAME)
    json_files = Csv2Json.new(OUTPUT_FILE).convert
  else
    puts "Unknown option!"
    puts "Please use either"
    puts "  json2csv - converts multiple json files to csv files and uplaods them to google drive"
    puts "  csv2json - converts a single csv file to multiple json files"
  end
end

main
