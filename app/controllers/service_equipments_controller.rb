class ServiceEquipmentsController < ApplicationController
  before_action :set_shop
  before_action :set_equipment, only: [:update, :destroy, :edit]
  after_action :verify_authorized

  def index
    authorize ServiceEquipment
    @q =  @shop.service_equipments.ransack(params[:q])
    @q.sorts = ['date_service desc', 'created_at desc'] if @q.sorts.empty?
    @equipments = @q.result(disinct: true)
    #@equipments = @shop.service_equipments
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
