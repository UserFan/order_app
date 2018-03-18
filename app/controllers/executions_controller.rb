class ExecutionsController < ApplicationController
  before_action :set_perform_execution, only: [:new, :edit, :create]
  before_action :set_execution, only: [:update, :destroy]
  after_action :verify_authorized

  def new
    authorize Execution
  end

  def edit
    authorize @execution
  end

  def create
    authorize Execution
    @execution_new = @performer.create_execution(permitted_attributes(Execution))    # Not the final implementation!
    if @execution_new.save
      redirect_to order_path(@performer.order)
    else
      render 'edit'
    end
  end

  def update
    authorize @execution
    if @execution.update_attributes(permitted_attributes(@execution))
     redirect_to order_path(@execution.performer.order)
    else
      render 'edit'
    end
  end

  def destroy
    authorize @execution
    if @execution.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to order_path(@execution.performer.order)
  end

  private

  def set_perform_execution
    @performer = Performer.find(params[:performer_id])
    @execution = @performer.execution || @performer.build_execution
  end

  def set_execution
    @execution = Execution.find(params[:id])
  end
end
