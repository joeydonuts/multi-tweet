module Merb
  module GlobalHelpers
    # helpers defined here available to all views.  
    def current_user
      @_current_user ||= User.get(session[:user])
    end

  end
end
