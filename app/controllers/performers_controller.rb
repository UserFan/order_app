class PerformersController < ApplicationController
  before_action :set_performer, only: [:update, :destroy, :edit]
  before_action :set_order
  before_action :set_collection_user, only: [ :new, :edit, :create ]
  after_action :verify_authorized

  def new
    authorize Performer
    if @users_performer.present?
      @performer = @order.performers.build(deadline: @order.date_execution - 1.days, message: true)
    else
      flash[:error] = "Все сотрудники отдела уже являються исполнителями!"
      redirect_to order_path(@order)
    end

  end

  def edit
    authorize @performer
  end

  def create
    authorize Performer
    @order.performers.present? ? first_performer = true : first_performer = false
    #binding.pry
    @performer= @order.performers.create(permitted_attributes(Performer).merge(
                deadline: @order.date_execution - 1.days))
    if @performer.save
      @order.update!(status_id: Status::EXECUTION) unless first_performer
      redirect_to order_path(@order)
    else
      render 'new'
    end
  end

  def update
    authorize @performer
    if @performer.update_attributes(permitted_attributes(@performer))
      redirect_to order_path(@order)
    else
      render 'edit'
    end
  end

  def destroy
    authorize @performer
    if @performer.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end

  end

  private

  def set_performer_order
    @performer = Performer.find(params[:id])
  end

  def set_order
    @order = Order.find(params[:order_id])
  end

  def set_collection_user
    @users_performer =  Employee.includes(:user, :shop).
                       where(manager: false, shops: {id: @order.employee.shop_id}).
                       where.not(id: @order.performers.pluck(:employee_id)).
                       where.not(id: @order.owner_user.employees.pluck(:id)).
                       joins(:user)
  end



end
