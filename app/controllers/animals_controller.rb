class AnimalsController < ApplicationController
  # A callback to set up an @animal object to work with 
  before_action :set_animal, only: [:show, :edit, :update, :destroy]

    def index
    # finding all the animals in alphabetical order and return as an array
    @animals = Animal.alphabetical.to_a
  end

  def show
    # get all the pets of that animal type that have been treated by PATS
    @pets = Pet.by_animal(@animal.id).paginate(:page => params[:page]).per_page(10)
  end

  def new
    @animal = Animal.new
  end

  def edit
  end

  def create
    @animal = Animal.new(animal_params)
    if @animal.save
      # if saved to database
      flash[:notice] = "Successfully created #{@animal.name}."
      redirect_to @animal # go to show animal page
    else
      # return to the 'new' form
      render action: 'new'
    end
  end

  def update
    if @animal.update_attributes(animal_params)
      flash[:notice] = "Successfully updated #{@animal.name}."
      redirect_to @animal
    else
      render action: 'edit'
    end
  end

  def destroy
    @animal.destroy
    flash[:notice] = "Successfully removed #{@animal.name} from the PATS system."
    redirect_to animals_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_animal
      @animal = Animal.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def animal_params
      params.require(:animal).permit(:name)
    end
end