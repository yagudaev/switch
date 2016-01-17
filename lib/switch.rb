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

  # TODO: need to ask for these on first run and store
  # in the secret file too
  CLIENT_ID = ENV['GOOGLE_DRIVE_CLIENT_ID']
  CLIENT_SECRET = ENV['GOOGLE_DRIVE_CLIENT_SECRET']
  SAVE_SESSION_FILE = "#{ENV['HOME']}/.googledrivesecret"

  FILE_NAME = File.basename(Dir.pwd) + '.csv'
  OUTPUT_DIR = "locales"

  # TODO:
  # * better file not found errors
  # * allow .switch files
  # --google-drive --no-local-file
  # `switch sync` runs a .switch file in the directory with
  # json2csv: locales locales.csv --google-drive --no-open
  # csv2json: locales.csv locales --google-drive --no-open
  # live switch - create a live replica
  # issue with order, when adding stuff in the middle to json file

  def self.run
    command = ARGV[0]
    input = ARGV[1]
    output = ARGV[2]

    case command
    when "json2csv"
      input ||= './locales/*'
      output ||=  FILE_NAME

      csv_file = Json2Csv.new(input).convert(output)

      # if google drive option is on
      client = CloudSync.new
      client.upload_to_drive(csv_file, output)
    when "csv2json"
      input ||= FILE_NAME
      output_dir = output || OUTPUT_DIR

      # if google drive option is on
      client = CloudSync.new
      local_input_csv = "#{output_dir}/#{input}"
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
