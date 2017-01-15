require_relative "../../lib/slice_model.rb"
class SliceToolController < ApplicationController
  before_action :require_user, :require_paid
  respond_to :json
  def index
    @continued = false
    if params["id"]
      template_id = params["id"]
      @template = Template.find(template_id)
      image_obj = UploadedImage.where(template_id: template_id).all
      @images = []
      image_obj.each do |image|
        @images.push(image.url)
      end
      @manager_state = 2
      @tracker_state = 2
      @continued = true
    end
  end

  def new
    puts "NEW"
    slices = SliceService.new(params)
    render json: slices.url_hash
  end

  def create
    puts params
  end

  #create controller that can take in params so we can send it to the react comnponent
  def continue
  end
end
