class UsersController < ApplicationController
  skip_before_filter :check_for_phone
  before_filter :permission_check

  def index
    @users = User.all
  end

  def edit
    @current_user = current_user
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      unless current_user.admin
        @user.admin = false
        @user.save
      end
      flash[:notice] = "Successfully updated user."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
  end
private
  def permission_check
    unless current_user.admin || (params[:id] && current_user == User.find(params[:id]))
      flash[:notice] = "You do not have access to that page"
      redirect_to root_url
    end
  end
end
