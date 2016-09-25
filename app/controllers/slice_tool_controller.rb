require_relative "../../lib/slice_model.rb"
class SliceToolController < ApplicationController
  respond_to :json
  def index
  end

  def new
    puts params
    SliceService.new(params)
    render json: "it's lit over here"
  end

  def create
    puts params
  end
end
