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
    # Set avatar for adopted pet
    case @pet.breed
    when 'Corgi'
      @pet.avatar = '/assets/images/corgi.png'
    when 'Golden Retriever'
      @pet.avatar = '/assets/images/labhead.png'
    when 'Pug'
      @pet.avatar = '/assets/images/pug.png'
    when 'Husky'
      @pet.avatar = '/assets/images/husky.png'
    end

    # Set unique petfinder pet id
    petfinderId = pet_info['id']['$t']
    @pet.unique_api_id = petfinderId

    # Set Shelter Id to be able to find location of animal
    shelterId = pet_info['shelterId']['$t']
    @pet.shelterId = shelterId

    # Set user that owns the pet
    @pet.user_id = session[:user_id]

    if @pet.save
        # call fucntion that set up needs
        need_create(@pet)
        redirect_to users_home_path, notice: "Meet your new pal #{@pet.name}!"
    else
      render :setup
    end
  end

  # This may need to be a protected method
  def pressing_need
    
  end

  protected

    def pet_params
      # Get name, breed, age, sex, desc, unique_api_id, and shelterId from api
      params.require(:pet).permit(:breed)
    end

    # Create needs for the pet
    def need_create(pet)
        needs = ['hunger', 'sleep', 'attention', 'happiness']
        needs.each do |ele|
            need = Need.new(pet_id: pet.id, need_description: ele)
            need.save    
        end
    end

    # Methods to get needs
    def hunger(pet)
        Need.where(:pet_id => pet.id).where(:need_description => 'hunger')
    end

    def sleep(pet)
       Need.where(:pet_id => pet.id).where(:need_description => 'sleep') 
    end

    def attention(pet)
        Need.where(:pet_id => pet.id).where(:need_description => 'attention')
    end

    def happiness(pet)
        Need.where(:pet_id => pet.id).where(:need_description => 'happiness')
    end
end