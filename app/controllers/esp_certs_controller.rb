class EspCertsController < ApplicationController
  before_action :set_esp, except: [:index, :show, :export_xls]
  before_action :set_esp_edit, only: [:update, :destroy, :edit]
  after_action :verify_authorized

  def index
    date_start = Date.today.beginning_of_month
    esp_certs = policy_scope(EspCert)
    @q = esp_certs.ransack(params[:q])
    @q.sorts = ['date_end_esp desc', 'created_at desc'] if @q.sorts.empty?
    @esp_certs = @q.result(disinct: true)
    authorize @esp_certs
    @esp_certs_count = esp_certs.size
    @count_esp_set_month = esp_certs.count_cert_esp(date_start)
    @count_esp_next_month = esp_certs.count_cert_esp(date_start.next_month)
    @count_rsa_set_month =  esp_certs.count_cert_rsa(date_start)
    @count_rsa_next_month = esp_certs.count_cert_rsa(date_start.next_month)
  end

  def new
    authorize @shop, policy_class: EspCertPolicy
    @esp_cert = policy_scope(@esp.esp_certs).build
  end

  def edit
    authorize @shop, :access_unit?, policy_class: EspCertPolicy
    end

  def create
    authorize @shop, policy_class: EspCertPolicy
    @esp_cert = @esp.esp_certs.create(permitted_attributes(EspCert))
    if @esp_cert.save
      redirect_to shop_esps_path(@esp.shop)
    else
      render 'new'
    end
  end

  def update
    authorize @shop, policy_class: EspCertPolicy
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
    @esp_xls = policy_scope(EspCert)
    authorize @esp_xls
    respond_to do |format|
      format.xlsx {
        render xlsx: "export_xls", filename: "esp_all.xlsx"
        }
    end
  end

  private

  def set_esp
    @esp =  policy_scope(Esp).find(params[:esp_id])
    @shop = Shop.find(params[:shop_id])
  end

  def set_esp_edit
    @esp_cert = @esp.esp_certs.find(params[:id])
  end
end
