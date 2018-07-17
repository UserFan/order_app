class ServiceEquipmentsController < ApplicationController
  before_action :set_shop
  before_action :set_equipment, only: [:update, :destroy, :edit]
  after_action :verify_authorized

  def index
    authorize ServiceEquipment
    date_start = DateTime.now.beginning_of_month
    date_end = DateTime.now.end_of_month
    @q =  @shop.service_equipments.includes(:equipment_type).ransack(params[:q])
    @q.sorts = ['date_service desc', 'created_at desc'] if @q.sorts.empty?
    @equipments = @q.result(disinct: true)
    @service_equipments_count = @shop.service_equipments.includes(:equipment_type).size
    @count_set_month = @shop.service_equipments.includes(:equipment_type).where('date_service >= ?' 'and date_service <= ?', date_start, date_end).size
    @count_prev_month = @shop.service_equipments.includes(:equipment_type).where('date_service >= ?' 'and date_service <= ?', date_start-1.month, date_end-1.month).size
  end

  def new
    authorize ServiceEquipment
    @equipment = @shop.service_equipments.build
  end

  def show
    authorize @equipment
  end

  def edit
    authorize @equipment
  end

  def create
    authorize Esp
    @equipment = @shop.service_equipments.create(permitted_attributes(ServiceEquipment))
    if @equipment.save
      redirect_to shop_service_equipments_path(@shop)
    else
      render 'new'
    end
  end

  def update
    authorize @equipment
    if @equipment.update_attributes(permitted_attributes(@equipment))
     redirect_to shop_service_equipments_path(@shop)
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
    redirect_to shop_service_equipments_path(@shop)
  end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def set_equipment
    @equipment = @shop.service_equipments.find(params[:id])
  end
end
