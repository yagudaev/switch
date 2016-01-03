require 'json'
require 'csv'
require 'google_drive'
require 'launchy'
require 'logger'

require 'dotenv'
Dotenv.load

require 'switch/extensions'
require 'switch/json2csv'
require 'switch/csv2json'
require 'switch/cloud_sync'

module Switch
  if ENV['TEST']
    @logger = Logger.new File.open('test.log', 'a')
  else
    @logger = Logger.new STDOUT
  end

  class << self
    attr_accessor :logger
  end

  CLIENT_ID = ENV['GOOGLE_DRIVE_CLIENT_ID']
  CLIENT_SECRET = ENV['GOOGLE_DRIVE_CLIENT_SECRET']
  SAVE_SESSION_FILE = "/tmp/switch_token.json"

  FILE_NAME = "locales.csv"
  OUTPUT_DIR = "/tmp"
  OUTPUT_FILE = "#{OUTPUT_DIR}/#{FILE_NAME}"

  def self.run
    command = ARGV[0]
    input = ARGV[1]
    output = ARGV[2]

    case command
    when "json2csv"
      input ||= './locales/*'
      output ||=  OUTPUT_FILE

      csv_file = Json2Csv.new(input).convert(output)

      # if google drive option is on
      file_name = output
      client = CloudSync.new
      client.upload_to_drive(csv_file, file_name)
    when "csv2json"
      input ||= FILE_NAME
      output_dir = output || OUTPUT_DIR

      # if google drive option is on
      client = CloudSync.new
      local_input_csv = "#{output_dir}/#{FILE_NAME}"
      client.download_from_drive(input, local_input_csv)

      json_files = Csv2Json.new(local_input_csv, output_dir).convert
    else
      puts "Unknown option!"
      puts "Please use either"
      puts "  json2csv - converts multiple json files to csv files and uplaods them to google drive"
      puts "  csv2json - converts a single csv file to multiple json files"
    end
  end
end
