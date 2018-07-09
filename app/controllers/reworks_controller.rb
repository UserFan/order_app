class ReworksController < ApplicationController
  before_action :set_execution_rework, only: [:new, :create]
  after_action :verify_authorized

  def new
    authorize Rework
    @rework = @execution.reworks.build(user_id: current_user.id)
    @remark = params[:execution_work]
  end

  def create
    authorize Rework
    @order = @execution.performer.order
    @rework = @execution.reworks.create(permitted_attributes(Rework))
    @remark = params[:execution_work]
    if @rework.save
      if @remark
        @execution.update!(order_execution: Status::NOT_COORDINATION, completed: nil)
        @order.update!(status_id: Status::NOT_COORDINATION)
      end
      redirect_to order_path(@order)
    elsif @remark
      redirect_to order_path(@order)
    else
      render 'new'
    end
  end

  private

  def set_execution_rework
    @execution = Execution.find(params[:execution_id])
  end

end
