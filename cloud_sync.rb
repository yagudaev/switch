CLIENT_ID = ENV['GOOGLE_DRIVE_CLIENT_ID']
CLIENT_SECRET = ENV['GOOGLE_DRIVE_CLIENT_SECRET']
SAVE_SESSION_FILE = "./output/stored_token.json"

class CloudSync
  def initialize
    puts "Connecting to google drive"
    @session = GoogleDrive.saved_session(SAVE_SESSION_FILE, nil, CLIENT_ID, CLIENT_SECRET)
  end

  def upload_to_drive(csv_file)
    puts "Uploading csv for json files"
    if file = @session.spreadsheet_by_title(FILE_NAME)
      puts "Detected old version of #{FILE_NAME}, updating file!"
      file.update_from_file(csv_file)
    else
      file = @session.upload_from_file(csv_file, FILE_NAME)
    end

    puts "You can find the new file here"
    puts file.human_url

    Launchy.open(file.human_url)
  end

  def download_from_drive(file_name)
    file = @session.spreadsheet_by_title(file_name)
    file.export_as_file(OUTPUT_FILE)

    puts "Downloaded to #{OUTPUT_FILE}"
  end
end
