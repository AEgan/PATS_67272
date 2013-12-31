class VaccinesController < ApplicationController
    # A callback to set up an @vaccine object to work with 
  before_action :set_vaccine, only: [:show, :edit, :update, :destroy]

  def index
    # get data on all vacines offered by PATS, 10 per page
    @vaccines = Vaccine.alphabetical.paginate(:page => params[:page]).per_page(10)
  end
  
  def show
  end
  
  def new
    @vaccine = Vaccine.new
  end
  
  def create
    @vaccine = Vaccine.new(vaccine_params)
    if @vaccine.save
      flash[:notice] = "Successfully added #{@vaccine.name} for #{@vaccine.animal.name} to PATS."
      redirect_to @vaccine
    else
      render action: 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @vaccine.update_attributes(vaccine_params)
      flash[:notice] = "Successfully updated #{@vaccine.name} for #{@vaccine.animal.name}."
      redirect_to @vaccine
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @vaccine = Vaccine.find(params[:id])
    @vaccine.destroy
    flash[:notice] = "Successfully destroyed #{@vaccine.name} for #{@vaccine.animal.name}."
    redirect_to vaccines_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_vaccine
    @vaccince = Vaccine.find(params[:id])
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def vaccine_params
    params.require(:vaccince).permit(:name, :animal_id, :duration)
  end
end
