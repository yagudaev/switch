module Switch
  class CloudSync
    def initialize
      Switch.logger.info "Connecting to google drive"
      @session = GoogleDrive.saved_session(SAVE_SESSION_FILE, nil, CLIENT_ID, CLIENT_SECRET)
    end

    def upload_to_drive(input, output)
      Switch.logger.info "Uploading csv for json files"
      if file = @session.spreadsheet_by_title(output)
        Switch.logger.info "Detected old version of #{output}, updating file!"
        file.update_from_file(input)
      else
        file = @session.upload_from_file(input, output)
      end

      Switch.logger.info "You can find the new file here"
      Switch.logger.info file.human_url

      Launchy.open(file.human_url)
    end

    def download_from_drive(input, output)
      file = @session.spreadsheet_by_title(input) || @session.spreadsheet_by_key(input)
      return Switch.logger.error "Cannot find file #{input}" unless file

      file.export_as_file(output, 'csv')

      Switch.logger.info "Downloaded file #{input} from google drive to #{output}"
    end
  end
end
