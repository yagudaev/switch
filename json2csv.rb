FILE_NAME = "translations.csv"
OUTPUT_FILE = "./output/#{FILE_NAME}"

class Json2Csv
  def initialize(dir)
    @dir = dir
  end

  def convert
    files = Dir[@dir].select{|f| File.extname(f) == '.json'}
    columns = columns_for_json(files)

    keys = get_keys_from(columns)
    columns = remove_missing_translations(keys, columns)
    columns = move_english_as_first_column(columns)

    rows = columns_to_rows(keys, columns)
    rows = add_order_column(rows)
    add_header(rows, columns)

    csv_file = OUTPUT_FILE
    puts "Writing local file to #{csv_file}"
    write_file(rows, csv_file)

    puts "Successfully conveted #{files.count}. File #{csv_file}"
    csv_file
  end

private
  def columns_for_json(files)
    columns = []

    files.each do |file_path|
      puts "Generating column for json file #{file_path}"
      language = File.basename(file_path, '.json')
      columns.push name: language, data: column_for_json(file_path)
    end

    columns
  end

  def column_for_json(file_path)
    data = JSON.parse(open(file_path).read)
    data = data.flatten_with_path
    data
  end

  def get_keys_from(columns)
    keys = []
    columns.each do |language|
      keys |= language[:data].keys
    end

    keys
  end

  def remove_missing_translations(keys, columns)
    columns = columns.dup
    keys.each do |key|
      columns.each do |lang|
        # e.g. 'CN_', 'ES_', etc
        pattern = Regexp.new('\A' + lang[:name].upcase + '_')
        # binding.pry unless lang[:data][key]
        if lang[:data][key] && lang[:data][key].match(pattern)
          lang[:data][key] = ''
        end
      end
    end
    columns
  end

  def move_english_as_first_column(columns)
    columns.unshift columns.delete_at(columns.index { |lang| lang[:name] == 'en' })
  end

  def columns_to_rows(keys, columns)
    rows = keys.map do |key|
      row = columns.map {|lang| lang[:data][key] }
      row.push(key)
      row
    end
  end

  def add_order_column(rows)
    rows.each_with_index do |row, i|
      row.push(i + 1)
    end
  end

  def add_header(rows, columns)
    rows.unshift (columns.map { |l| l[:name] } + ["keys", "order"])
  end

  def write_file(rows, csv_file)
    CSV.open(csv_file, "wb") do |csv|
      rows.each do |row|
        csv << row
      end
    end
  end
end
