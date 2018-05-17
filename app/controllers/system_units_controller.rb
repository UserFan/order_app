class SystemUnitsController < ApplicationController
  before_action :set_system_unit, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize SystemUnit
    @q =SystemUnit.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @system_units = @q.result(disinct: true)
    render partial: "catalog/catalog_list",
            locals: { q: @q,
                      title: t('.caption_title'),
                      caption_button: t('.caption_button'),
                      main_collection: @system_units,
                      new_path: url_for(action: 'new') }
  end

  def show
    authorize @system_unit
  end

  def new
    authorize SystemUnit
    @system_unit = SystemUnit.new
  end

  def edit
    authorize @system_unit
  end

  def create
    authorize SystemUnit
    @system_unit = SystemUnit.new(permitted_attributes(SystemUnit))    # Not the final implementation!
    if @system_unit.save
      redirect_to system_units_path
    else
      render 'new'
    end
  end

  def update
    authorize @system_unit
    if @system_unit.update_attributes(permitted_attributes(@system_unit))
      redirect_to system_units_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @system_unit
    if @system_unit.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to system_units_path
  end


  private

  def set_system_unit
    @system_unit = SystemUnit.find(params[:id])
  end
end
