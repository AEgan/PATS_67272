class VaccinationsController < ApplicationController
    # A callback to set up an @vaccination object to work with 
  before_action :set_vaccination, only: [:show, :edit, :update, :destroy]

  def index
    # get all the data on vaccinations in the system, 10 per page
    @vaccinations = Vaccination.chronological.paginate(:page => params[:page]).per_page(10)
  end

  def show
  end

  def new
    @vaccination = Vaccination.new
  end

  def edit
  end

  def create
    @vaccination = Vaccination.new(vaccination_params)
    if @vaccination.save
      flash[:notice] = "Successfully created vaccination."
      redirect_to @vaccination
    else
      render action: 'new'
    end
  end

  def update
    if @vaccination.update_attributes(vaccination_params)
      flash[:notice] = "Successfully updated vaccination."
      redirect_to @vaccination
    else
      render action: 'edit'
    end
  end

  def destroy
    @vaccination.destroy
    flash[:notice] = "Successfully destroyed vaccination."
    redirect_to vaccinations_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_vaccination
    @vaccination = Vaccination.find(params[:id])
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def vaccination_params
    params.require(:vaccination).permit(:vaccine_id, :visit_id, :dosage)
  end
end
