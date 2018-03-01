class ExecutionsController < ApplicationController

  #before_action :set_execution only: [:edit, :update, :destroy ]
  before_action :set_performer, except: [:index]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize Execution
  end

  def show
    authorize @execution
  end

  def new
    authorize Execution
    @execution = Execution.new
  end

  def edit
    authorize @execution
  end

  def create

    authorize Execution
    @execution = @performer.executions.build(Execution)    # Not the final implementation!
    if @execution.save
      redirect_to @executions_path
    else
      render 'new'
    end
  end

  def update
    authorize @execution
    if @execution.update_attributes(permitted_attributes(@execution))
     redirect_to executions_path
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
    redirect_to executions_path
  end


  private

  def set_performer
    @performer = Performer.find(params[:performer_id])
  end

  def set_execution
    @execution = Execution.find(params[:id])
  end
end
