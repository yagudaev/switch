require 'csv'
require 'json'
require 'pry'

class Csv2Json
  def initialize(file)
    @file = file
  end

  def convert
    @rows = CSV.read(@file)
    @header = @rows.shift

    order_index = @header.index 'order'
    @rows.sort! {|a, b| a[order_index].to_i <=> b[order_index].to_i }

    files = []
    languages = @header - ['keys', 'order']
    for lang in languages
      data = extract_hash_for(lang)
      files.push write_json_file(lang, data)
    end

    files
  end

private
  def extract_hash_for(lang)
    hash = {}
    lang_index = @header.index lang
    key_index = @header.index 'keys'
    en_lang_index = @header.index 'en'

    raise "No key column found!" unless key_index

    @rows.each do |row|
      hash[row[key_index]] = get_value(lang, row[lang_index], row[en_lang_index])
    end

    hash = dot_notation_to_nested_hash(hash)
  end

  def get_value(lang, value, en_value)
    en_value ||= ""
    value = value || "#{lang.upcase}_#{en_value}"
    # multi-line json string support
    value = value.split("\n")
    value = value[0] if value.count == 1
    value
  end

  def write_json_file(lang, data)
    file_path = "./output/#{lang}.json"
    File.open(file_path, "w") do |f|
      f.write(JSON.pretty_generate(data))
    end

    puts "Wrote file #{file_path}"

    file_path
  end

  # http://stackoverflow.com/a/4366196/1321251
  def dot_notation_to_nested_hash(hash)
    hash.map do |main_key, main_value|
      main_key.to_s.split(".").reverse.inject(main_value) do |value, key|
        {key.to_sym => value}
      end
    end.inject(&:merge)
  end
end
