class PetsController < ApplicationController
  # Using respond_to method so we can have output in different formats besides HTML
  respond_to :html, :xml, :json

  # A callback to set up an @pet object to work with 
  before_action :set_pet, only: [:show, :edit, :update, :destroy]

  
  def index
    # get data on all pets and paginate the output to 10 per page
    @pets = Pet.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    respond_with @pets
  end

  def show
    # get the last 10 visits for this pet
    @recent_visits = @pet.visits.last(10).to_a
    respond_with @pet
  end

  def new
    @pet = Pet.new
  end

  def edit
  end

  def create
    @pet = Pet.new(pet_params)
    if @pet.save
      redirect_to @pet, notice: "Successfully added #{@pet.name} as a PATS pet."
    else
      render action: 'new'
    end
  end

  def update
    if @pet.update_attributes(pet_params)
      redirect_to @pet, notice: "Updated #{@pet.name}'s information"
    else
      render action: 'edit'
    end
  end

  def destroy
    @pet.destroy
    redirect_to pets_url, notice: "Removed #{@pet.name} from the PATS system"
  end

  def females
    @pets = Pet.females.alphabetical.to_a
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_pet
    @pet = Pet.find(params[:id])
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def pet_params
    params.require(:pet).permit(:name, :animal_id, :owner_id, :female, :date_of_birth, :active)
  end


end
