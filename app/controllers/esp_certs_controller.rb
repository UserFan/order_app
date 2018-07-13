class EspCertsController < ApplicationController
  before_action :set_esp, except: [:index, :show]
  before_action :set_esp_edit, only: [:update, :destroy, :edit]
  after_action :verify_authorized

  def new
    authorize EspCert
    @esp_cert = @esp.esp_certs.build
  end

  def edit
    authorize @esp_cert
  end

  def create
    authorize EspCert
    @esp_cert = @esp.esp_certs.create(permitted_attributes(EspCert))
    if @esp_cert.save
      redirect_to shop_esps_path(@esp.shop)
    else
      render 'new'
    end
  end

  def update
    authorize @esp_cert
    if @esp_cert.update_attributes(permitted_attributes(@esp_cert))
     redirect_to shop_esps_path(@esp.shop)
    else
      render 'edit'
    end
  end

  def destroy
    authorize @esp_cert
    if @esp_cert.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to shop_esps_path(@esp.shop)
  end

  private

  def set_esp
    @esp = Esp.find(params[:esp_id])
    @shop = Shop.find(params[:shop_id])
  end

  def set_esp_edit
    @esp_cert = @esp.esp_certs.find(params[:id])
  end
end
