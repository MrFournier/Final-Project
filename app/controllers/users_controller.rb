class UsersController < ApplicationController

  def new 
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
        session[:user_id] = @user.id
        redirect_to user_path_setup, notice: "Welcome to "
    else
      # TODO render erb new
    end
  end

  def setup
    render :setup
  end

  protected

    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :email)
    end

end
