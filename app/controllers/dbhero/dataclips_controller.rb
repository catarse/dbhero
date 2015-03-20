require_dependency "dbhero/application_controller"

module Dbhero
  class DataclipsController < ApplicationController
    before_action :set_dataclip, only: [:show, :edit, :update, :destroy]
    respond_to :html, :csv

    # GET /dataclips
    def index
      @dataclips = Dataclip.all
    end

    # GET /dataclips/1
    def show
      @dataclip.query_result

      respond_to do |format|
        format.html
        format.csv do
          send_data @dataclip.csv_string, type: Mime::CSV, disposition: "attachment; filename=#{@dataclip.token}.csv"
        end
      end
    end

    # GET /dataclips/new
    def new
      @dataclip = Dataclip.new
    end

    # GET /dataclips/1/edit
    def edit
      @dataclip.check_query
    end

    # POST /dataclips
    def create
      @dataclip = Dataclip.create(dataclip_params)
      respond_with @dataclip, location: edit_dataclip_path(@dataclip),notice: 'Dataclip was successfully created.'
    end

    # PATCH/PUT /dataclips/1
    def update
      @dataclip.update(dataclip_params)
      respond_with @dataclip, location: edit_dataclip_path(@dataclip), notice: 'Dataclip was successfully updated.'
    end

    # DELETE /dataclips/1
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
        params.require(:dataclip).permit(:description, :raw_query)
      end
  end
end
