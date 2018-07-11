class ShopsController < ApplicationController
  before_action :set_shop, except: [:index, :new, :create]
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
    #$host_shop = params[:host_shop]
    CashCash.connection_pool.clear_reloadable_connections!
    CashCash.establish_connection(connect_timeout: 5,
                                  adapter:  "postgresql",
                                  host:     params[:host_shop],
                                  username: "postgres",
                                  password: "postgres",
                                  database: "set")
    begin
      cash_remote = CashCash.find_by(cash_ip: cashbox.ip_cash) if CashCash.exists?
      if (cash_remote.present? && cashbox.update!(fiscal_fwversion: cash_remote.fwversion,
                         cash_set_version: cash_remote.version))
        flash[:error] = "Обновление данных прошло успешно!"
      else
        flash[:error] = "Не удалось обновить данные. По данной кассе данные отсуствуют"
      end
    rescue
      flash[:error] = "Подключение к ПО кассы отсуствует!"
    end
    redirect_to shop_path(cashbox.shop)
  end

  private

  def set_shop
    @shop = Shop.find(params[:id])
  end

  def set_index
    if current_user.super_admin? || current_user.moderator? #|| current_user.guide?
      @q = Shop.includes(:user, :orders, :type, :cashboxes, :computers,
                         :shop_weighers, :shop_communications).ransack(params[:q])
      @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
      @shops = @q.result(disinct: true)
      @shops_closed = Shop.includes(:user, :orders, :type, :cashboxes, :computers,
                         :shop_weighers, :shop_communications).ransack(closed_not_null: '1').result.count
      @shops_open = Shop.includes(:user, :orders, :type, :cashboxes, :computers,
                         :shop_weighers, :shop_communications).ransack(closed_not_null: '0').result.count
      @shops_count = Shop.count
    else
      @q = current_user.shops.includes(:user, :orders, :type, :cashboxes, :computers,
                         :shop_weighers, :shop_communications).ransack(params[:q])
      @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
      @shops = @q.result(disinct: true)
      @shops_closed = current_user.shops.includes(:user, :orders, :type, :cashboxes, :computers,
                         :shop_weighers, :shop_communications).ransack(closed_not_null: '1').result.count
      @shops_open = current_user.shops.includes(:user, :orders, :type, :cashboxes, :computers,
                         :shop_weighers, :shop_communications).ransack(closed_not_null: '0').result.count
      @shops_count = current_user.shops.count
    end
  end
  end
