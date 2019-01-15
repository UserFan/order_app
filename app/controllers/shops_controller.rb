class ShopsController < ApplicationController
  after_action :verify_authorized
  before_action :authenticate_user!, :set_structural_unit
  before_action :set_shop, except: [:index, :new, :create, :version_update, :export_shops]
  #before_action :set_index, only: [:index]

  def index
    authorize @@set_units
  end

  def show
    authorize @shop
    @shop_manager = @shop.shop_manager
  end

  def new
    authorize @@set_units
    @shop = @@set_units.new(type_id: @set_unit ? 4 : 1)
  end

  def edit
    authorize @shop
  end

  def create
    authorize @@set_units
    @shop = @@set_units.create(permitted_attributes(@@set_units))    # Not the final implementation!
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
      redirect_to shops_path, notice: t("#{params[:unit]}.shops.destroy.success")
    else
      redirect_to shops_path, notice: t("#{params[:unit]}.shops.destroy.error")
    end
  end

  def import_version
    authorize @shop
    cashbox = Cashbox.find(params[:cashbox_id])
    remote_set_connection(params[:host_shop])
    begin
      cash_remote = CashCash.find_by(cash_ip: cashbox.ip_cash) if CashCash.exists?
      if (cash_remote.present? && cashbox.update!(fiscal_fwversion: cash_remote.fwversion,
                         cash_set_version: cash_remote.version))
        flash[:success] = t("version_update_text.update_success")
      else
        flash[:alert] =  t("version_update_text.not_update")
      end
    rescue
      flash[:error] = t("version_update_text.not_connection")
    end
    respond_to do |format|
      #format.json { render json: { cash_set_version: cashbox.cash_set_version, fiscal_fwversion: cashbox.fiscal_fwversion } }
      format.json { render json: { cash_set_version: 1, fiscal_fwversion: 2 } }
      #redirect_to shop_path(cashbox.shop)
    end
  end

  def version_update
    shops = Shop.includes(:user, :orders, :type, :cashboxes, :computers,
                  :shop_weighers, :shop_communications).where('closed is null and structural_unit = false')
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
                       :shop_weighers, :shop_communications).where(structural_unit: @set_unit)
    @cashboxes_count = @shops_xls.maximum('cashboxes_count')
    @computers_count = @shops_xls.maximum('computers_count')
    @communication_count = @shops_xls.maximum('shop_communications_count')
    @weighers_count = @shops_xls.maximum('shop_weighers_count')
    @communication_item_count = ShopCommunication.maximum('item_communications_count')

    respond_to do |format|
      format.xlsx {
        render xlsx: "export_shops", filename: "shop_all.xlsx"
        }
    end
  end

  private

  def set_structural_unit
    if current_user.super_admin? || current_user.moderator? || current_user.guide?
      set_shops = Shop.includes(:orders, :type, :cashboxes, :computers,
                         :shop_weighers, :shop_communications)
    else
      set_shops = current_user.shops.includes(:orders, :type, :cashboxes, :computers,
                                       :shop_weighers, :shop_communications)
    end

    @users_shop = User.includes(:profile).where(admin: false).order('profiles.surname ASC')

    if params[:unit] == 'structural'
      @@set_units = set_shops.structural_unit
      @type_select = Type.where(id: 4)
      @structural = true
    elsif params[:unit] == 'shop'
      @@set_units =  set_shops.shop_unit
      @type_select = Type.where.not(id: 4)
      @structural = false
    else
      flash[:error] = "Страница не найдена!"
      redirect_to root_path
    end

    shop_char = []
    @q = @@set_units.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @shops = @q.result(disinct: true)
    @shops_closed = @@set_units.ransack(closed_not_null: '1').result.count
    @shops_open = @@set_units.ransack(closed_not_null: '0').result.count
    @shops_count = @@set_units.size
    @shops.each { |shop| shop_char << shop.name[0].upcase }
    @shops_filter_char = shop_char.uniq.sort

  end

  def set_shop
    @shop = @@set_units.find(params[:id])
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
