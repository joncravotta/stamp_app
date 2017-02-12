class AccountsController < ApplicationController
  before_action :require_user

  def index
    @account = Account.find(current_user.account_id)
    @users = User.where(account_id: @account.id)
  end

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

  def destroy
    User.find(params[:id]).destroy
    flash[:notice] = "Successfully deleted"
    redirect_to accounts_path
  end

  def make_admin
    parameters = user_params

    @user = User.find(parameters[:user_id])
    @user.update(
      admin: true
    )
    @user.save

    flash[:notice] = "#{@user.email} is now an admin"
    redirect_to accounts_path
  end

  def remove_admin
    parameters = user_params
    @user = User.find(parameters[:user_id])
    @user.update(
      admin: false
    )
    @user.save

    flash[:notice] = "#{@user.email} has been removed as an admin"
    redirect_to accounts_path
  end

  def remove_user_from_account
    parameters = user_params
    @user = User.find(parameters[:user_id])
    @account = Account.find(@user.account_id)
    @account.update(
      seat_count: @account.seat_count + 1
    )
    @account.save
    @user.destroy

    flash[:notice] = "Successfully removed"
    redirect_to accounts_path
  end

  private

  def safe_params
    params.require(:account).permit(:company_name)
  end

  def user_params
    params.require(:account).permit(:user_id)
  end
end
