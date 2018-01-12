class OrganizationUnitsController < ApplicationController
  before_action :set_type, except: [ :index, :new, :create ]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize OrganizationUnit
    @q =OrganizationUnit.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @organization_units = @q.result(disinct: true)
    #@positions = Position.all
  end

  def show
    authorize @organization_unit
  end

  def new
    authorize OrganizationUnit
    @organization_unit = OrganizationUnit.new
  end

  def edit
    authorize @organization_unit
  end

  def create
    authorize OrganizationUnit
    @organization_unit = OrganizationUnit.new(permitted_attributes(OrganizationUnit))    # Not the final implementation!
    if @organization_unit.save
      redirect_to organization_units_path
    else
      render 'new'
    end
  end

  def update
    authorize @organization_unit
    if @organization_unit.update_attributes(permitted_attributes(@organization_unit))
     redirect_to organization_units_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @organization_unit
    if @organization_unit.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to organization_units_path
  end


  private

  def set_type
    @organization_unit = OrganizationUnit.find(params[:id])
  end
end
