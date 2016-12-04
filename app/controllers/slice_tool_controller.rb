require_relative "../../lib/slice_model.rb"
class SliceToolController < ApplicationController
  respond_to :json
  def index
  end

  def new
    puts params
    slices = SliceService.new(params)
    render json: slices.url_hash
  end

  def create
    puts params
  end
end
