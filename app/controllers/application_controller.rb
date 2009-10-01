# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :current_user
  
  before_filter CASClient::Frameworks::Rails::Filter
  before_filter :first_time_user

  def current_user
    @current_user ||= User.find_by_login(session[:cas_user])
  end
  
  def first_time_user
    if current_user.nil?
      flash[:notice] = "Hey there! Since this is your first time making a reservation, we'll
        need you to supply us with some basic contact information first."
      redirect_to new_user_path
    end
  end
  
  def logout
    @current_user = nil
    CASClient::Frameworks::Rails::Filter.logout(self)
  end
end
