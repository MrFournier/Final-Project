class UserController < ApplicationController

  def new 
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
        session[:user_id] = @user.id
        redirect_to home_path, notice: "Welcome to "
    else
      # TODO render erb new
    end
  end

  protected

    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :email)
    end

end
