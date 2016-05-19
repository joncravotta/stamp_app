class BuildController < ApplicationController
  respond_to :json
  def new
    puts "called"
    template = params
    @build = EmailBuilderService.new(template)
    respond_with @build
  end
end
