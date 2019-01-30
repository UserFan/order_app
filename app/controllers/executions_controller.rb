class ExecutionsController < ApplicationController
  before_action :set_perform_execution, only: [:new, :edit, :create]
  before_action :set_execution, only: [:update, :destroy, :show, :coordination]
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
    if @execution_new.save
      unless [Status::OFF_CONTROL].include?(@execution_new.order_execution)
        @order.update!(status_id: Status::COORDINATION)
      end
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
    if @execution.update_attributes(completed: DateTime.now, order_execution: Status::AGREE)
      respond_to do |format|
         format.html { redirect_to order_path(@order) }
         format.json { head :no_content }
         format.js   { render layout: false }
      end
    end
  end

  def remove_control
    authorize Execution
    @performer = Performer.find(params[:performer_id])
    @order = @performer.order
    @execution = @performer.build_execution(completed: DateTime.now,
                 order_execution: Status::OFF_CONTROL,
                 comment: 'Снято с контроля(без исполнения)!')
    if @execution.save
      #binding.pry
      #@performer.update!(date_close_performance: DateTime.now) unless @performer.date_close_performance.present?
      redirect_to order_path(@order)
    end
  end


  def destroy
    authorize @execution
    @order = @execution.performer.order
    if @execution.destroy
      @order.update!(status_id: Status::EXECUTION)
      #@execution.performer.update!(date_close_performance: nil)
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
