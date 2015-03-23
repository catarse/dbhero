require_dependency "dbhero/application_controller"
require_dependency "responders"
require_dependency "google/api_client"
require_dependency "google_drive"

module Dbhero
  class DataclipsController < ApplicationController
    before_action :check_auth, except: [:show]
    before_action :set_dataclip, only: [:show, :edit, :update, :destroy]
    respond_to :html, :csv

    def index
      @dataclips = Dataclip.ordered
    end

    def drive
      @dataclip = Dataclip.find_by(token: session.delete(:clip_token))
      @dataclip.check_query
      auth_google.code = params[:code]
      auth_google.fetch_access_token!
      session = GoogleDrive.login_with_oauth(auth_google.access_token)
      file = session.upload_from_string("", "#{@dataclip.description} - #{@dataclip.token}_#{Time.now.to_i}", content_type: 'text/csv')
      ws = file.worksheets[0]
      ws[1,1] = "=importData('#{dataclip_url(@dataclip, format: 'csv')}')"
      ws.save
      redirect_to file.human_url
    end

    def show
      check_auth if @dataclip.private?
      @dataclip.query_result

      respond_to do |format|
        format.html do
          if params[:export_gdrive]
            session[:clip_token] = @dataclip.token

            redirect_to auth_google.authorization_uri.to_s
          end
        end
        format.csv do
          send_data @dataclip.csv_string, type: Mime::CSV, disposition: "attachment; filename=#{@dataclip.token}.csv"
        end
      end
    end

    def new
      @dataclip = Dataclip.new
    end

    def edit
      @dataclip.query_result
    end

    def create
      @dataclip = Dataclip.create(dataclip_params.merge(user: user_representation))
      respond_with @dataclip, location: edit_dataclip_path(@dataclip),notice: 'Dataclip was successfully created.'
    end

    def update
      @dataclip.update(dataclip_params)
      respond_with @dataclip, location: edit_dataclip_path(@dataclip), notice: 'Dataclip was successfully updated.'
    end

    def destroy
      @dataclip.destroy
      redirect_to dataclips_url, notice: 'Dataclip was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_dataclip
        @dataclip = Dataclip.find_by_token(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def dataclip_params
        params.require(:dataclip).permit(:description, :raw_query, :private)
      end

      def auth_google
        @g_client ||= ::Google::APIClient.new
        auth = @g_client.authorization
        #auth.application_name = 'DBHero'
        auth.client_id = ""
        auth.client_secret = ""
        auth.scope =
          "https://www.googleapis.com/auth/drive " +
          "https://spreadsheets.google.com/feeds/"

        auth.redirect_uri = drive_dataclips_url
        auth
      end
  end
end
