module Dbhero
  class GdriveExporter
    attr_accessor :options
    attr_reader :client, :auth, :session,
      :dataclip, :uploaded_file, :exported_file_url

    def initialize options = {}
      @client ||= ::Google::APIClient.new
      @options = options

      @auth = @client.authorization
      @auth.client_id = Dbhero.google_api_id
      @auth.client_secret = Dbhero.google_api_secret
      @auth.scope =
        "https://www.googleapis.com/auth/drive " +
        "https://spreadsheets.google.com/feeds/"

      @auth.redirect_uri = options[:redirect_uri]
    end

    def fetch_access_token! code
      @auth.code = code
      @auth.fetch_access_token!
      @session ||= GoogleDrive.login_with_oauth(@auth.access_token)
    end

    def export_clip_by_token token
      @dataclip ||= Dataclip.find_by token: token
      raise 'unable to find dataclip' unless @dataclip

      exported_file = find_or_create_spreadsheet!
      @exported_file_url = exported_file.human_url
    end

    private

    def find_or_create_spreadsheet!
      file_title = "DBHero - #{@dataclip.title}"
      worksheet = upload_from_string(file_title).worksheets[0]
      worksheet[1,1] = "=importData(\"#{@options[:import_data_url]}\")"
      worksheet.save

      @uploaded_file
    end

    def upload_from_string file_title
      @uploaded_file ||= @session.upload_from_string(
        "",
        file_title,
        content_type: 'text/csv')
    end
  end
end
