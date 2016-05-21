Gem::Specification.new do |s|
  s.name        = 'switch-cli'
  s.version     = '0.0.5'
  s.executables << 'switch'
  s.date        = '2016-05-20'
  s.summary     = "Command-line utility to convert translation files to spreadsheet and vice-versa"
  s.description = "Switch helps you add multiple languages to your site by leveraging the power of google spreadsheets. It is a commandline tool providing you with an easy way to automate the process and avoid common mistakes.

  The most common use case of switch is for switching between a locale representation in JSON/YAML to a CSV (spreadsheet) based one and vice-versa.

  # Install

  ```
  gem install switch-cli
  ```

  # Usage

  ```
  switch json2csv [input-dir] [output-file]
  ```

  Converts multiple json files to be a single csv file with columns for each file, with the file name as the column header.

  If you do not specify an input-dir it will be taken as ./locales and output-file would be the direcotry name + .csv.

  ```
  switch csv2json [input-file] [output-dir]
  ```

  Converts a single csv file into multiple json files, with a file for each column using the key and order columns to construct the files.
  "
  s.authors     = ["Michael Yagudaev"]
  s.email       = 'michael@yagudaev.com'
  s.files       = ["lib/switch.rb", "lib/switch/cloud_sync.rb", "lib/switch/csv2json.rb",
    "lib/switch/extensions.rb", "lib/switch/json2csv.rb"]
  s.homepage    = 'https://github.com/yagudaev/switch'
  s.license     = 'MIT'

  # run time
  s.add_runtime_dependency 'dotenv', '~> 2.0'
  s.add_runtime_dependency 'google_drive', '~> 1.0'
  s.add_runtime_dependency 'launchy', '~> 2.4'
  s.add_runtime_dependency 'deep_merge', '~> 1.0'

  # dev
  s.add_development_dependency 'pry', '~> 0.9.12'
  s.add_development_dependency 'rspec', '~> 3.4'
end
