class Csv2Json
  def initialize(file)
    @file = file
  end

  def convert
    @rows = CSV.read(@file)
    # sort by order

    languages = @rows[0] - ['keys', 'order']
    for lang in languages
      data = extract_hash_for(lang)
      write_json_file(lang, data)
    end
  end

private
  def extract_hash_for(lang)
    hash = {}
    lang_column = @rows[0].index lang
    key_column = @rows[0].index 'keys'

    raise "No key column found!" unless key_column

    @rows[1..-1].each do |row|
      hash[row[key_column]] = row[lang_column] || ""
    end

    hash = dot_notation_to_nested_hash(hash)
  end

  def write_json_file(lang, data)
    file_path = "./output/#{lang}.json"
    File.open(file_path, "w") do |f|
      f.write(JSON.pretty_generate(data))
    end

    puts "Wrote file #{file_path}"
  end

  # http://stackoverflow.com/a/4366196/1321251
  def dot_notation_to_nested_hash(hash)
    hash.map do |main_key, main_value|
      main_key.to_s.split(".").reverse.inject(main_value) do |value, key|
        {key.to_sym => value}
      end
    end.inject(&:deep_merge)
  end
end
