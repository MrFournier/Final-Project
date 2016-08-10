class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected

    def restrict_access
      if !current_user
        puts 'here'
        flash[:alert] = "You must be logged in."
        redirect_to '/'
      end
    end

    def current_user
      @current_user || User.find(session[:user_id]) if session[:user_id]
    end

    helper_method :current_user
end
