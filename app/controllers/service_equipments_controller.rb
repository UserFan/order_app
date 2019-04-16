class ServiceEquipmentsController < ApplicationController
  before_action :set_shop
  before_action :set_equipment, only: [:update, :destroy, :edit]
  after_action :verify_authorized

  def index
    authorize ServiceEquipment
    date_start = DateTime.now.beginning_of_month
    date_end = DateTime.now.end_of_month
    @q =  @shop.nil? ? ServiceEquipment.includes(:equipment_type).ransack(params[:q]) :
          @shop.service_equipments.includes(:equipment_type).ransack(params[:q])
    @q.sorts = ['date_service desc', 'created_at desc'] if @q.sorts.empty?
    @equipments = @q.result(disinct: true)
    @service_equipments_count = @equipments.size
    @count_set_month = @equipments.where('date_service >= ?' 'and date_service <= ?', date_start, date_end).size
    @count_prev_month = @equipments.where('date_service >= ?' 'and date_service <= ?', date_start-1.month, date_end-1.month).size
  end

  def new
    authorize ServiceEquipment
    unless @shop.nil?
      @equipment = ServiceEquipment.new(shop_id: @shop.id)
    else
      @equipment = ServiceEquipment.new
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
    @equipment = ServiceEquipment.create(permitted_attributes(ServiceEquipment))
    if @equipment.save
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
  end

  def set_equipment
    @equipment = ServiceEquipment.find(params[:id])
  end
end
