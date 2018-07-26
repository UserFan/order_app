class ShopsController < ApplicationController
  before_action :set_shop, except: [:index, :new, :create, :version_update, :export_shops]
  before_action :set_index, only: [:index]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize Shop
  end

  def show
    authorize @shop
  end

  def new
    authorize Shop
    @shop = Shop.new
  end

  def edit
    authorize @shop
  end

  def create
    authorize Shop
    @shop = Shop.new(permitted_attributes(Shop))    # Not the final implementation!
    if @shop.save
      redirect_to shops_path
    else
      render 'new'
    end

  end

  def update
    authorize @shop
    if @shop.update_attributes(permitted_attributes(@shop))
      redirect_to shops_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @shop
    if @shop.destroy
      flash[:success] = "Торговый объект удачно удален."
    else
      flash[:error] = "Торговый объект не может буть удален. Есть связанные данные"
    end
    redirect_to shops_path
  end

  def import_version
    authorize @shop
    cashbox = Cashbox.find(params[:cashbox_id])
    remote_set_connection(params[:host_shop])
    begin
      cash_remote = CashCash.find_by(cash_ip: cashbox.ip_cash) if CashCash.exists?
      if (cash_remote.present? && cashbox.update!(fiscal_fwversion: cash_remote.fwversion,
                         cash_set_version: cash_remote.version))
        flash[:error] = t("version_update_text.update_success")
      else
        flash[:error] =  t("version_update_text.not_update")
      end
    rescue
      flash[:error] = t("version_update_text.not_connection")
    end
    redirect_to shop_path(cashbox.shop)
  end

  def version_update
    shops = Shop.includes(:user, :orders, :type, :cashboxes, :computers,
                  :shop_weighers, :shop_communications).where('closed is null')
    shops.find_each do |shop|
      authorize (shop)
      shop.computers.present? ? ip_address = shop.computers.first.ip_address : ip_address = '0.0.0.0'
      remote_set_connection(ip_address)
      if shop.cashboxes.any?
        shop.cashboxes.find_each do |cashbox|
          begin
            cash_remote = CashCash.find_by(cash_ip: cashbox.ip_cash) if CashCash.exists?
            if (cash_remote.present? && cashbox.update!(fiscal_fwversion: cash_remote.fwversion,
                                                        cash_set_version: cash_remote.version))
              VersionUpdateLog.create!(shop_id: shop.id, date_log: DateTime.now,
                 text_log: t("version_update_text.update_success"), result_update: 1)
            else
              VersionUpdateLog.create!(shop_id: shop.id, date_log: DateTime.now,
                text_log: t("version_update_text.not_update"), result_update: 0)
            end
          rescue
            VersionUpdateLog.create!(shop_id: shop.id, date_log: DateTime.now,
              text_log: t("version_update_text.not_connection"), result_update: 0)
          end
        end
      else
        VersionUpdateLog.create!(shop_id: shop.id, date_log: DateTime.now,
          text_log: t("version_update_text.cash_not_and_ip"), result_update: 0)
      end
    end
    redirect_to version_update_logs_path
  end

  def export_shops
    authorize Shop
    @shops_xls = Shop.includes(:user, :orders, :type, :cashboxes, :computers,
                       :shop_weighers, :shop_communications)
    respond_to do |format|
      format.xlsx {
        render xlsx: "export_shops", filename: "shop_all.xlsx"
        }
    end
  end

  private

  def set_shop
    @shop = Shop.find(params[:id])
  end

  def set_index
    if current_user.super_admin? || current_user.moderator? #|| current_user.guide?
      set_shops = Shop.includes(:user, :orders, :type, :cashboxes, :computers,
                         :shop_weighers, :shop_communications)
    else
      set_shops = current_user.shops.includes(:user, :orders, :type, :cashboxes, :computers,
                                       :shop_weighers, :shop_communications)
    end
    @q = set_shops.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @shops = @q.result(disinct: true)
    @shops_closed = set_shops.ransack(closed_not_null: '1').result.count
    @shops_open = set_shops.ransack(closed_not_null: '0').result.count
    @shops_count = set_shops.size
  end

  def remote_set_connection(ip_address)
    CashCash.connection_pool.clear_reloadable_connections!
    CashCash.establish_connection(connect_timeout: 5,
                                  adapter:  "postgresql",
                                  host:     ip_address,
                                  username: "postgres",
                                  password: "postgres",
                                  database: "set")
  end

  end
