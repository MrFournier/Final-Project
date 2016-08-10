class PetsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # Make a get request to the api using the petid from the post request
    dog = params[:pet][:dog]

    conn = Faraday.new(:url => 'http://api.petfinder.com')
    response = conn.get ('/pet.get?&key='+ ENV['PETFINDER_API'] +'&id='+ dog +'&format=json')

    # Create a new instance of pet to save the pet to
    body = JSON.parse(response.body)
    pet_info = body['petfinder']['pet']

    @pet = Pet.new(pet_params)

    # Set pet name
    name = pet_info['name']['$t']
    @pet.name = name

    # Set pet age
    age = pet_info['age']['$t']
    @pet.age = age

    # Set pet sex
    sex = pet_info['sex']['$t']
    @pet.sex = sex

    # Set pet adoption status
    @pet.adopted = true

    # Switch to be used when dog avatars are ready
    # case @pet.breed
    # when 'Corgi'
    #   @pet.avatar = corgi avatar
    # when 'Golden Retriever'
    #   @pet.avatar = 
    # when 'Pug'
    #   @pet.avatar = 
    # when 'Husky'
    #   @pet.avatar = 
    # end

    # Set unique petfinder pet id
    petfinderId = pet_info['id']['$t']
    @pet.unique_api_id = petfinderId

    # Set Shelter Id to be able to find location of animal
    shelterId = pet_info['shelterId']['$t']
    @pet.shelterId = shelterId

    # Set user that owns the pet
    @pet.user_id = session[:user_id]

    # testing
    puts @pet.name
    puts @pet.breed
    puts @pet.sex
    puts @pet.age
    puts @pet.shelterId
    puts @pet.unique_api_id
    puts @pet.id
    puts @pet.user_id

    # @user = session[:user_id]
    # @user.pet_id = 

    # if @pet.save
    # 
    # else
    #   render :setup
    # end
  end

  def pressing_need
    
  end

  protected

    def pet_params
      # Get name, breed, age, sex, desc, unique_api_id, and shelterId from api
      params.require(:pet).permit(:breed)
    end

end