require 'json'
require 'csv'
require 'google_drive'
require 'launchy'
require 'logger'

require 'dotenv'
Dotenv.load

require './lib/switch/extensions'
require './lib/switch/json2csv'
require './lib/switch/csv2json'
require './lib/switch/cloud_sync'

module Switch
  puts "defined a logger!"
  @logger = Logger.new File.open('test.log', 'a')

  class << self
    attr_accessor :logger
  end

  CLIENT_ID = ENV['GOOGLE_DRIVE_CLIENT_ID']
  CLIENT_SECRET = ENV['GOOGLE_DRIVE_CLIENT_SECRET']
  SAVE_SESSION_FILE = "./output/stored_token.json"

  FILE_NAME = "translations.csv"
  OUTPUT_FILE = "./output/#{FILE_NAME}"

  def run
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
end
