class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      # TODO redirect to game page
      redirect_to users_home_path, notice: "Welcome back, #{user.username}!"
    else
      flash.now[:alert] = "Log in failed..."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/', notice: "*Dog cry*"
  end
end
