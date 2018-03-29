class ExecutionsController < ApplicationController
  before_action :set_perform_execution, only: [:new, :edit, :create]
  before_action :set_execution, only: [:update, :destroy, :show, :completed, :coordination]
  after_action :verify_authorized

  def new
    authorize Execution
  end

  def show
    authorize @execution
  end

  def edit
    authorize @execution
  end

  def create
    authorize Execution
    @execution_new = @performer.create_execution(permitted_attributes(Execution))
        # Not the final implementation!
    if @execution_new.save
      @order.update!(status_id: 5)
      redirect_to order_path(@performer.order)
    else
      render 'new'
    end
  end

  def update
    authorize @execution
    if @execution.update_attributes(permitted_attributes(@execution))
     redirect_to order_path(@execution.performer.order)
    else
      render 'new'
    end
  end

  def coordination
    authorize @execution
    @order = @execution.performer.order
    @order.update!(status_id: Status::AGREE)
    redirect_to order_path(@order) if @execution.update_attributes(completed: DateTime.now, order_execution: Status::AGREE)
  end
  

  def destroy
    authorize @execution
    @order = @execution.performer.order
    if @execution.destroy
      @order.update!(status_id: 2)
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to order_path(@execution.performer.order)
  end

  private

  def set_perform_execution
    @performer = Performer.find(params[:performer_id])
    @order = @performer.order
    @execution = @performer.execution || @performer.build_execution(order_execution: Status::COORDINATION)
  end

  def set_execution
    @execution = Execution.find(params[:id])
  end

end
