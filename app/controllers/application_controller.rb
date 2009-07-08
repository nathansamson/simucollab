# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  rescue_from 'Acl9::AccessDenied', :with => :access_denied

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    
    def require_user
      unless current_user
        flash[:notice] = "You must be logged in to access this page"
        redirect_to root_url
        return false
      end
    end
 
    def require_no_user
      if current_user
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end
    
    def access_denied
      if current_user == nil
        flash[:notice] = "You must be logged in to access this page"
      else
        flash[:notice] = "Access denied"
      end
      redirect_to root_url
    end

end
