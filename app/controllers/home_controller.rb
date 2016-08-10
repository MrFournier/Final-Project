class HomeController < ApplicationController

  def index
    @user = User.new
    render :index
  end
end