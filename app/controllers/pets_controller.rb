class PetsController < ApplicationController

  def new 

  end

  def create

  end

  protected

    # Not sure if I need because no input from user
    # is taken to create the pet
    # def pet_params
    #   params.require(:pet).permit(:name, :breed, :age, :sex, :description)
    # end

end