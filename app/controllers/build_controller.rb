class BuildController < ApplicationController
  respond_to :json
  def new
    #TODO White list these params
    #template = params
    @template = Template.find(params["templateId"])
    @build = EmailBuilderService.new(template)
    # respond_to do |format|
    #   format.json { render text: @build.response }
    #   format.text { render text: @build.response }
    # end
    @user = User.find(current_user)
    #TODO clean up user model
    @user.update(header: params["header"], footer: params["footer"], url_path: params["urlPath"], email_width: params["emailWidth"], header_active: params["headerCodeActive"], footer_active: params["footerCodeActive"])
    @template.update(html: @build.response, completed: true)
    if @template.save
      puts "LOG: Email saved"
    else
      puts "LOG: Email could not be saved"
    end
    if @build
      render json: @build.response
    else
      render json: 'Something went wrong'
    end
  end
end
