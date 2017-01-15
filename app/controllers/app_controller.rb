class AppController < ApplicationController
  before_action :require_user, :require_paid
  def index
  end
end
