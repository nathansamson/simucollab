class Admin::UserController < ApplicationController
    
    access_control do
        allow :admin
    end
    
    def index
        @users = User.all
    end
    
    def show
        @user = User.find(params[:id])
        @roles = [:admin, :gamemanager] # TODO: fix this, so each controller has its roles
    end
    
    def revoke
        @user = User.find(params[:id])
        @role = params[:role]
        
        @user.has_no_role!(@role, nil)
        flash[:notice] = "Revoked role"
        redirect_to admin_user_path(@user)
    end
    
    def assign
        @user = User.find(params[:id])
        @role = params[:role]
        
        @user.has_role!(@role, nil)
        flash[:notice] = "Assigned role"
        redirect_to admin_user_path(@user)
    end
end
