class TemplatesController < ApplicationController
  before_action :require_user, :require_paid
  def index
    @templates = Template.where(user_id: current_user.id)
  end

  def show
    @template = Template.find(params[:id])
  end
end
