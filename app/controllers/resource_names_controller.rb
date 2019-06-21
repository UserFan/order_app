class ResourceNamesController < ApplicationController
  before_action :set_resource_name, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize ResourceName
    @q = ResourceName.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @resource_names = @q.result(disinct: true)
  end

  def show
    authorize @resource_name
  end

  def new
    authorize ResourceName
    @resource_name = ResourceName.new
  end

  def edit
    authorize @resource_name
  end

  def create
    authorize ResourceName
    @resource_name = ResourceName.new(permitted_attributes(ResourceName))    # Not the final implementation!
    if @resource_name.save
      redirect_to resource_names_path
    else
      render 'new'
    end
  end

  def update
    authorize @resource_name
    if @resource_name.update_attributes(permitted_attributes(@resource_name))
      redirect_to resource_names_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @resource_name
    if @resource_name.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to resource_names_path
  end


  private

  def set_resource_name
    @resource_name = ResourceName.find(params[:id])
  end
end
