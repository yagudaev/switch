module Switch
  class CloudSync
    def initialize
      Switch.logger.info "Connecting to google drive"
      @session = GoogleDrive.saved_session(SAVE_SESSION_FILE, nil, CLIENT_ID, CLIENT_SECRET)
    end

    def upload_to_drive(csv_file)
      Switch.logger.info "Uploading csv for json files"
      if file = @session.spreadsheet_by_title(FILE_NAME)
        Switch.logger.info "Detected old version of #{FILE_NAME}, updating file!"
        file.update_from_file(csv_file)
      else
        file = @session.upload_from_file(csv_file, FILE_NAME)
      end

      Switch.logger.info "You can find the new file here"
      Switch.logger.info file.human_url

      Launchy.open(file.human_url)
    end

    def download_from_drive(file_name)
      file = @session.spreadsheet_by_title(file_name)
      file.export_as_file(OUTPUT_FILE)

      Switch.logger.info "Downloaded to #{OUTPUT_FILE}"
    end
  end
end
