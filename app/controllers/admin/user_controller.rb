class Admin::UserController < ApplicationController
  before_filter :find_user, :only => [:show, :revoke, :assign]
    
  access_control do
    allow :admin
  end

  def index
    @users = User.all
  end

  def show
    @roles = [:admin, :gamemanager] # TODO: fix this, so each controller has its roles
  end

  def revoke
    @role = params[:role]
    
    @user.has_no_role!(@role, nil)
    flash[:notice] = "Revoked role"
    redirect_to admin_user_path(@user)
  end

  def assign
    @role = params[:role]
    
    @user.has_role!(@role, nil)
    flash[:notice] = "Assigned role"
    redirect_to admin_user_path(@user)
  end

  private
    def find_user
      begin
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:notice] = "User not found"
        redirect_to admin_user_index_path
      end
    end
end
