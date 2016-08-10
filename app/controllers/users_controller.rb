class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :restrict_access, except: [:create]

  def create
    puts 'users controller'
    @user = User.new(user_params)
    puts "USER INFO BELOW"
    puts user_params

    if @user.save
        session[:user_id] = @user.id
        redirect_to users_setup_path, notice: "Welcome to Rescue Pals!"
    else
      # TODO render erb new
      redirect_to '/', notice: 'User creation failed.'
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      # TODO redirect to game page
    else
      render :setup
    end
  end

  def setup
    render :setup
  end

  def home
    render :home
  end

  protected

    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :email)
    end
end
