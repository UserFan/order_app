class EnumResourcesController < ApplicationController
  before_action :set_enum_resource, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize EnumResource
    @q = EnumResource.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @enum_resources = @q.result(disinct: true)
  end

  def show
    authorize @enum_resource
  end

  def new
    authorize EnumResource
    @enum_resource = EnumResource.new
  end

  def edit
    authorize @enum_resource
  end

  def create
    authorize EnumResource
    @enum_resource = EnumResource.new(permitted_attributes(EnumResource))    # Not the final implementation!
    if @enum_resource.save
      redirect_to enum_resources_path
    else
      render 'new'
    end
  end

  def update
    authorize @enum_resource
    if @enum_resource.update_attributes(permitted_attributes(@enum_resource))
      redirect_to enum_resources_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @enum_resource
    if @enum_resource.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to enum_resources_path
  end


  private

  def set_enum_resource
    @enum_resource = EnumResource.find(params[:id])
  end
end
