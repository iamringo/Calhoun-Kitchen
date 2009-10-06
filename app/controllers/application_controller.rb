# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter CASClient::Frameworks::Rails::Filter
  before_filter :check_for_phone
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
protected

  def current_user
    if u = User.find_by_netid(session[:cas_user])
      u
    else
      User.import_from_ldap(session[:cas_user])
    end

  end

private

  def check_for_phone
    unless current_user.phone
      redirect_to edit_user_path(current_user)
    end
  end

end
