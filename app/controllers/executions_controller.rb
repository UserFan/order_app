class ExecutionsController < ApplicationController

  before_action :set_param_execution, except: [:index, :new, :create]
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
    @execution = Execution.new()
  end

  def edit
    authorize @execution
  end

  def create
    authorize Execution
    binding.pry
    @execution = @performer.create_execution(permitted_attributes(Execution))    # Not the final implementation!
    if @execution.save
      redirect_to order_path(@performer.order)
    else
      render 'new'
    end
  end

  def update
    authorize @execution
    if @execution.update_attributes(permitted_attributes(@execution))
     redirect_to order_path(@performer.order)
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

  def set_param_execution
    @execution = Execution.find(params[:id])
  end
end
