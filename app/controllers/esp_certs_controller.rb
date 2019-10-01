class EspCertsController < ApplicationController
  before_action :set_esp, except: [:index, :show, :export_xls]
  before_action :set_esp_edit, only: [:update, :destroy, :edit]
  after_action :verify_authorized

  def index
    authorize EspCert
    date_start = Date.today.beginning_of_month
    date_start_next =  date_start.next_month
    @q = policy_scope(EspCert).ransack(params[:q])
    @q.sorts = ['date_end_esp desc', 'created_at desc'] if @q.sorts.empty?
    @esp_certs = @q.result(disinct: true)
    @esp_certs_count = @esp_certs.size
    @count_esp_set_month = policy_scope(EspCert).count_cert_esp(date_start)
    @count_esp_next_month = @esp_certs.count_cert_esp(date_start_next)
    @count_rsa_set_month =  @esp_certs.count_cert_rsa(date_start)
    @count_rsa_next_month = @esp_certs.count_cert_rsa(date_start_next)
  end

  def new
    #authorize EspCert
    @esp_cert = @esp.esp_certs.build
    authorize @esp_cert
  end

  def edit
    authorize @esp_cert
  end

  def create
    #authorize EspCert
    @esp_cert = @esp.esp_certs.create(permitted_attributes(EspCert))
    authorize @esp_cert
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
    #authorize EspCert
    # @esp_xls =
    #   if EspCert.roles(current_user).join == 'allowed_all'
    #     EspCert.includes(:shop, :esp).order('shops.name asc')
    #   else
    #     EspCert.joins(:esp).where(esps: { shop_id: current_user.current_shops })
    #   end
    #   authorize @esp_xls
    # respond_to do |format|
    #   format.xlsx {
    #     render xlsx: "export_xls", filename: "esp_all.xlsx"
    #     }
    # end
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
