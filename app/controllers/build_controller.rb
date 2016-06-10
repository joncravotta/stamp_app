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
    @user = User.find(current_user)
    @user.update(header: template["header"], footer: template["footer"], url_path: template["urlPath"], email_width: template["emailWidth"], header_active: template["headerCodeActive"], footer_active: template["footerCodeActive"])
    if @build
      render json: @build.response
    else
      render json: 'Something went wrong'
    end
  end
end
