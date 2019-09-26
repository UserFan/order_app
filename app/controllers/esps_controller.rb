class EspsController < ApplicationController
  before_action :set_shop
  before_action :set_esp, only: [:update, :destroy, :edit]
  after_action :verify_authorized

  def index
    authorize Esp
    @esps = @shop.esps
  end

  def new
    authorize Esp
    @esp = @shop.esps.build
  end

  def edit
    authorize @esp    
  end

  def create
    authorize Esp
    @esp = @shop.esps.create(permitted_attributes(Esp))
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
    @esp = @shop.esps.find(params[:id])
  end
end
