class EspsController < ApplicationController
  before_action :set_shop
  before_action :set_esp, only: [:update, :destroy, :edit]
  after_action :verify_authorized, except: :index
  #after_action :verify_policy_scoped, only: :index

  def index
    @esps = policy_scope(@shop.esps)
    authorize @esps
    #binding.pry
    #binding.pry
  end

  def new
    @esp = policy_scope(@shop.esps).build
    authorize @esp
    #authorize @esp
    binding.pry
  end

  def edit
    authorize @esp
  end

  def create
    #authorize Esp
    @esp = policy_scope(@shop.esps).create(permitted_attributes(Esp))
    authorize @esp
    if @esp.save
      redirect_to shop_esps_path(@shop)
    else
      render 'new'
    end
  end

  def update
    authorize @esp
    if @esp.update_attributes(permitted_attributes(@esp))
     redirect_to shop_esps_path(@shop)
    else
      render 'edit'
    end
  end

  def destroy
    authorize @esp
    if @esp.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to shop_esps_path(@shop)
  end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def set_esp
    @esp = policy_scope(@shop.esps).find(params[:id])
    authorize @esp
  end
end
