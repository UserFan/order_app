class ProvidersController < ApplicationController

  before_action :set_type, except: [ :index, :new, :create ]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize Provider
    @q =Provider.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @providers = @q.result(disinct: true)
    #@positions = Position.all
  end

  def show
    authorize @provider
  end

  def new
    authorize Provider
    @provider = Provider.new
  end

  def edit
    authorize @provider
  end

  def create
    authorize Provider
    @provider = Provider.new(permitted_attributes(Provider))    # Not the final implementation!
    if @provider.save
      redirect_to providers_path
    else
      render 'new'
    end
  end

  def update
    authorize @provider
    if @provider.update_attributes(permitted_attributes(@provider))
     redirect_to providers_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @provider
    if @provider.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to providers_path
  end


  private

  def set_type
    @provider = Provider.find(params[:id])
  end
end