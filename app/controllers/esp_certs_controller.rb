class EspCertsController < ApplicationController
  before_action :set_esp, except: [:index, :show, :export_xls]
  before_action :set_esp_edit, only: [:update, :destroy, :edit]
  after_action :verify_authorized

  def index
    authorize EspCert
    date_start = Date.today.beginning_of_month
    date_end = Date.today.end_of_month
    date_end_next = Date.today.next_month.end_of_month
    @q = EspCert.includes(:shop, :esp).ransack(params[:q])
    @q.sorts = ['date_end_esp desc', 'created_at desc'] if @q.sorts.empty?
    @esp_certs = @q.result(disinct: true)
    @esp_certs_count = EspCert.includes(:shop, :esp).size
    @count_esp_set_month = EspCert.count_cert_esp(date_start, date_end)
    @count_esp_next_month = EspCert.count_cert_rsa(date_start, date_end)
    @count_rsa_set_month = EspCert.count_cert_esp(date_start, date_end_next)
    @count_rsa_next_month = EspCert.count_cert_rsa(date_start, date_end_next)
    # @count_esp_set_month = EspCert.includes(:shop, :esp).where(date_end_esp: date_start..date_end).size
    # @count_esp_next_month = EspCert.includes(:shop, :esp).where(date_end_esp:  date_start.next_month..Date.today.next_month.end_of_month).size
    # @count_rsa_set_month = EspCert.includes(:shop, :esp).where(date_end_rsa: date_start..date_end).size
    # @count_rsa_next_month = EspCert.includes(:shop, :esp).where(date_end_rsa: date_start.next_month..Date.today.next_month.end_of_month).size
  end

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

  def export_xls
    authorize EspCert
    @esp_xls = EspCert.includes(:shop, :esp).order('shops.name asc')


    respond_to do |format|
      format.xlsx {
        render xlsx: "export_xls", filename: "esp_all.xlsx"
        }
    end
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
