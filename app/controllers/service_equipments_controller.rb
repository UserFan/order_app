class ServiceEquipmentsController < ApplicationController
  before_action :set_shop
  before_action :set_equipment, only: [:update, :destroy, :edit]
  after_action :verify_authorized

  def index
    date_start = DateTime.now.beginning_of_month
    service_equipments =
      @shop.nil? ? policy_scope(ServiceEquipment) : policy_scope(@shop.service_equipments)
    @q =  service_equipments.ransack(params[:q])
    @q.sorts = ['date_service desc', 'created_at desc'] if @q.sorts.empty?
    @equipments = @q.result(disinct: true)
    authorize @equipments
    @service_equipments_count = service_equipments.size
    @count_set_month = service_equipments.service_period_count(date_start)
    @count_prev_month =service_equipments.service_period_count(date_start.prev_month)
  end

  def new
    unless @shop.nil?
      authorize @shop, policy_class: ServiceEquipmentPolicy
      @shop.service_equipments.build
    else
      authorize @shops, policy_class: ServiceEquipmentPolicy
      @equipment = policy_scope(ServiceEquipment).new
    end
  end

  def show
    authorize @equipment
  end

  def edit
    authorize @equipment
  end

  def create
    authorize ServiceEquipment
    @equipment =
      @shop.nil? ? policy_scope(ServiceEquipment) : @shop.service_equipments
    if @equipment.create(permitted_attributes(ServiceEquipment))
      redirect_to service_equipments_path(shop_id: @shop)
    else
      render 'new'
    end
  end

  def update
    authorize @equipment
    if @equipment.update_attributes(permitted_attributes(@equipment))
      redirect_to service_equipments_path(@shop)
    else
      render 'edit'
    end
  end

  def destroy
    authorize @equipment
    if @equipment.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to service_equipments_path(shop_id: @shop)
  end

  private

  def set_shop
    @shop = params[:shop_id] ? Shop.find(params[:shop_id]) : nil
    @shop_filter ||= params[:filter_shop]
    binding.pry
    #if policy(:ServiceEquipment).new?

    @shops = policy_scope(Shop)
    #else
    #  @shops = Shop.all
  #  end
  end

  def set_equipment
    @equipment = policy_scope(ServiceEquipment).find(params[:id])
    binding.pry
  end
end
