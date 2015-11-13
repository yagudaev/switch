!#/bin/ruby

require 'json'
require 'csv'
require './extensions'

def column_for_json(file_path)
  data = JSON.parse(open(file_path).read)
  data = data.flatten_with_path
  data
end

def upload_to_drive(file_path)
end

def main
  files = Dir['./data/*'].select{|f| File.extname(f) == '.json'}
  languages = []

  files.each do |file_path|
    puts "Generating column for json file #{file_path}"
    language = File.basename(file_path, '.json')
    languages.push name: language, data: column_for_json(file_path)
  end

  # get keys
  keys = []
  languages.each do |language|
    keys |= language[:data].keys
  end

  # convert to rows
  rows = keys.map do |key|
    row = languages.map {|lang| lang[:data][key] }
    row.push(key)
    row
  end

  # add header
  rows.unshift (languages.map { |l| l[:name] } + ["key"])

  # write file
  CSV.open("output/translations.csv", "wb") do |csv|
    rows.each do |row|
      csv << row
    end
  end

  # puts "Uploading csv for json files"
  # upload_to_drive(csv_file)

  puts "Done all work. Successfully conveted #{files.count}"
end

main
