class CostEquipmentsController < ApplicationController
  before_action :set_shop
  before_action :set_cost_equipment, only: [:update, :destroy, :edit]
  after_action :verify_authorized

  def index
    authorize CostEquipment
    date_start = DateTime.now.beginning_of_month
    date_end = DateTime.now.end_of_month
    @q =  @shop.cost_equipments.includes(:cost_type).ransack(params[:q])
    @q.sorts = ['date_cost desc', 'created_at desc'] if @q.sorts.empty?
    @cost_equipments = @q.result(disinct: true)
    @cost_equipments_count = @shop.cost_equipments.includes(:cost_type).size
    @count_set_month = @shop.cost_equipments.includes(:cost_type).where('date_cost >= ?' 'and date_cost <= ?', date_start, date_end).size
    @count_prev_month = @shop.cost_equipments.includes(:cost_type).where('date_cost >= ?' 'and date_cost <= ?', date_start-1.month, date_end-1.month).size
    #@equipments = @shop.service_equipments
  end

  def new
    authorize CostEquipment
    @cost_equipment = @shop.cost_equipments.build
  end

  def show
    authorize @cost_equipment
  end

  def edit
    authorize @cost_equipment
  end

  def create
    authorize Esp
    @cost_equipment = @shop.cost_equipments.create(permitted_attributes(CostEquipment))
    if @cost_equipment.save
      redirect_to shop_cost_equipments_path(@shop)
    else
      render 'new'
    end
  end

  def update
    authorize @cost_equipment
    if @cost_equipment.update_attributes(permitted_attributes(@cost_equipment))
     redirect_to shop_cost_equipments_path(@shop)
    else
      render 'edit'
    end
  end

  def destroy
    authorize @cost_equipment
    if @cost_equipment.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to shop_cost_equipments_path(@shop)
  end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end

  def set_cost_equipment
    @cost_equipment = @shop.cost_equipments.find(params[:id])
  end
end
