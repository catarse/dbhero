require_dependency "dbhero/application_controller"
require_dependency "responders"
require_dependency "google/api_client"
require_dependency "google_drive"

module Dbhero
  class DataclipsController < ApplicationController
    before_action :check_auth, except: [:show]
    before_action :set_dataclip, only: [:show, :edit, :update, :destroy]
    has_scope :search
    respond_to :html, :csv

    def index
      @dataclips = apply_scopes(Dataclip.ordered)
    end

    def drive
      token = session.delete(:clip_token)

      google_client.fetch_access_token!(params[:code])
      google_client.options[:import_data_url] = dataclip_url(id: token, format: 'csv')
      google_client.export_clip_by_token token

      redirect_to dataclip_path(google_client.dataclip, gdrive_file_url: google_client.exported_file_url)
    end

    def show
      check_auth if @dataclip.private?

      @dataclip.query_result

      respond_to do |format|
        format.html do
          if params[:export_gdrive]
            session[:clip_token] = @dataclip.token
            redirect_to google_client.auth.authorization_uri.to_s
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

      def google_client
        @g_client ||= Dbhero::GdriveExporter.new(redirect_uri: drive_dataclips_url)
      end
  end
end
