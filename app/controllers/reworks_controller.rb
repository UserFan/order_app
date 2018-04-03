class ReworksController < ApplicationController
  before_action :set_execution_rework, only: [:new, :create]
  after_action :verify_authorized

  def new
    authorize Rework
    @rework = @execution.reworks.build(user_id: current_user.id)
    @@work_new = params[:execution_work]
  end

  def create
    authorize Rework
    @order = @execution.performer.order
    @rework = @execution.reworks.create(permitted_attributes(Rework))
        # Not the final implementation!
    if @rework.save
      if @@work_new
        @execution.update!(order_execution: Status::NOT_COORDINATION)
        @order.update!(status_id: Status::NOT_COORDINATION)
      end
      redirect_to order_path(@order)
    else
      render 'new'
    end
  end

  def destroy
    # authorize @reworks
    # @order = @execution.performer.order
    # if @execution.destroy
    #   @order.update!(status_id: 2)
    #   flash[:success] = "Запись удачно удален."
    # else
    #   flash[:error] = "Запись не может буть удален. Есть связанные данные"
    # end
    # redirect_to order_path(@execution.performer.order)
  end

  private

  def set_execution_rework
    @execution = Execution.find(params[:execution_id])
  end

end
