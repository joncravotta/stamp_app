class BuildController < ApplicationController
  respond_to :json
  def new
    puts "called"
    template = params
    @build = EmailBuilderService.new(template)
    # respond_to do |format|
    #   format.json { render text: @build.response }
    #   format.text { render text: @build.response }
    # end
    if @build
      render json: @build.response
    else
      render json: 'Something went wrong'
    end
  end
end
