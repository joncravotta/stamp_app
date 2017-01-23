class AccountsController < ApplicationController
  before_action :require_user

  def new
    @account = Account.new
  end

  def create
    @user = User.find(current_user.id)
    parameters = safe_params
    if @user
      @account = Account.new(
        created_by: @user.email,
        company_name: parameters[:company_name],
        company_name_digital: company_name_stipper(parameters[:company_name])
      )
      @account.save

      @user.account_id = @account.id
      @user.save

      redirect_to new_charge_path
    else
      # TODO error handling here
    end
  end

  private

  def safe_params
    params.require(:account).permit(:company_name)
  end
end
