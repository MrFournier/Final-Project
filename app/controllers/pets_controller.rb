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

  def home
    render :home
  end

  def get_pet
    user = session[:user_id]
    pet = Pet.where(:user_id => user)
    return pet
  end

  # Method to checktimestamps
  def checkTimeStamps
    pet = get_pet()

    petHunger = get_hunger(pet)
    petSleep = get_sleep(pet)
    petAttention = get_attention(pet)
    petHappiness = get_happiness(pet)

    currentTime = Time.now.utc()

    # Currently these checks are over engineered, use second param, on dec methods, of
    # number of times to make the call only once
    # Checks
    timeDiff = currentTime - petHunger.updated_at
    timeDiff = timeDiff.round
    if (timeDiff > 10800) && (petHunger.status > 0)
        n = (timeDiff/10800).floor
        n = 10 if (n > 10) 
        # Make call to decrement hunger method
        dec_hunger(petHunger, n)
    end

    timeDiff = currentTime - petSleep.updated_at
    timeDiff = timeDiff.round
    if (timeDiff > 21600) && (petSleep.status > 0)
        n = (timeDiff/21600).floor
        n = 2 if (n > 2)
        dec_sleep(petSleep, n)
    end

    timeDiff = currentTime - petAttention
    timeDiff = timeDiff.round
    if (timeDiff > 900) && (petAttention.status > 0)
        n = (timeDiff/900).floor
        n = 20 if (n > 20)
        dec_attention(petAttention)
    end

    # Do something with happiness its going to be a little more complicated

  end

  # This may need to be a protected method
  # Checks the status(value) of every need and returns the most desperate need
  def pressing_need
    user = session[:user_id]
    pet = Pet.where(:user_id => user)

    lowestNeed = 0
    pressing_need = ''

    hunger = get_hunger(pet)
    if hunger.status < lowestNeed
        lowestNeed = hunger.status
        pressing_need = hunger.need_description
    end

    sleep = get_sleep(pet)
    if sleep.status < lowestNeed
        lowestNeed = sleep.status
        pressing_need = sleep.need_description
    end

    attention = get_attention(pet)
    if attention.status < lowestNeed
        lowestNeed = attention.status
        pressing_need = attention.need_description
    end
    return pressing_need
  end

  def inc_hunger
    pet = get_pet()
    hunger = get_hunger(pet)
    hunger.status += 40
    hunger = checkInRange(hunger)
    hunger.save
  end

  def inc_sleep
    pet = get_pet()
    sleep = get_sleep(pet)
    sleep.status += 50
    sleep = checkInRange(sleep)
    sleep.save
  end

  def inc_attention
    pet = get_pet()
    attention = get_attention(pet)
    attention.status += 5
    attention = checkInRange(attention)
    attention.save
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
    def get_hunger(pet)
        hunger = Need.where(:pet_id => pet.id).where(:need_description => 'hunger')
        return hunger
    end

    def get_sleep(pet)
       sleep = Need.where(:pet_id => pet.id).where(:need_description => 'sleep')
       return sleep
    end

    def get_attention(pet)
        attention = Need.where(:pet_id => pet.id).where(:need_description => 'attention')
        return attention
    end

    def get_happiness(pet)
        hapiness = Need.where(:pet_id => pet.id).where(:need_description => 'happiness')
        return happiness
    end

    # Methods to decrement dog needs
    def dec_hunger(need, n)
        need.status = need.status - (10 * n)
        need = checkInRange(need)
        need.save
    end

    def dec_sleep(need, n)
        need.status = need.status - (50 * n)
        need = checkInRange(need)
        need.save
    end

    def dec_attention(need, n)
        need.status = need.status - (5 * n)
        need = checkInRange(need)
        need.save
    end

    def dec_happiness(need, n)

    end

    # Methods to incremnet dog happiness
    def inc_happiness

    end

    # Check if need value is in range
    def checkInRange(need)
        if need.status < 0
            need.status = 0
            return need
        end
        if need.status > 100
            need.status = 100
            return need
        end
        return need
    end
end