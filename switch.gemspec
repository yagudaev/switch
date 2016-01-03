Gem::Specification.new do |s|
  s.name        = 'switch'
  s.version     = '0.0.1'
  s.executables << 'switch'
  s.date        = '2016-01-02'
  s.summary     = "Command-line utility to convert translation files to spreadsheet and vice-versa"
  s.description = "Your application likely consumes .json or .yml files, editing then by hand
  as a developer is fine. If you are a translator/client without programming background editing
  these files is difficult. Moreover, when you get more than 5 languages it is hard to keep track
  what translations are still pending.

  What you really want is a simple spreadsheet you can all collaberate on.
  With a simple command you can make it all come true:

  ```
  switch json2csv ./locales ./tmp --google-drive
  ```

  This will take all the json files in the locale directory and convert them
  to a single csv file under ./tmp/locales.csv it will then upload the file
  to google drive and open it
  "
  s.authors     = ["Michael Yagudaev"]
  s.email       = 'michael@yagudaev.com'
  s.files       = ["lib/switch.rb", "lib/switch/cloud_sync.rb", "lib/switch/csv2json.rb",
    "lib/switch/extensions.rb", "lib/switch/json2csv.rb"]
  s.homepage    = 'http://rubygems.org/gems/switch'
  s.license     = 'MIT'

  # run time
  s.add_runtime_dependency 'dotenv', '~> 2.0'
  s.add_runtime_dependency 'google_drive', '~> 1.0'
  s.add_runtime_dependency 'launchy', '~> 2.4'

  # dev
  s.add_development_dependency 'pry', '~> 0.9.12'
  s.add_development_dependency 'rspec', '~> 3.4'
end
