class KeyboardsController < ApplicationController

  before_action :set_type, except: [ :index, :new, :create ]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize Keyboard
    @q = Keyboard.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @keyboards = @q.result(disinct: true)
    #@positions = Position.all
  end

  def show
    authorize @keyboard
  end

  def new
    authorize Keyboard
    @keyboard = Keyboard.new
  end

  def edit
    authorize @keyboard
  end

  def create
    authorize Keyboard
    @keyboard = Keyboard.new(permitted_attributes(Keyboard))    # Not the final implementation!
    if @keyboard.save
      redirect_to keyboards_path
    else
      render 'new'
    end
  end

  def update
    authorize @keyboard
    if @keyboard.update_attributes(permitted_attributes(@keyboard))
     redirect_to keyboards_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @keyboard
    if @keyboard.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to keyboards_path
  end


  private

  def set_type
    @keyboard = Keyboard.find(params[:id])
  end
end
