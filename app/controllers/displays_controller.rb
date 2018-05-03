class DisplaysController < ApplicationController

  before_action :set_type, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Display
    @q = Display.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @displays = @q.result(disinct: true)
    render layout: "catalogs"
    #@positions = Position.all
  end

  def show
    authorize @display
  end

  def new
    authorize Display
    @display = Display.new
  end

  def edit
    authorize @display
  end

  def create
    authorize Display
    @display = Display.new(permitted_attributes(Display))    # Not the final implementation!
    if @display.save
      redirect_to displays_path
    else
      render 'new'
    end
  end

  def update
    authorize @display
    if @display.update_attributes(permitted_attributes(@display))
     redirect_to displays_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @display
    if @display.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to displays_path
  end


  private

  def set_type
    @display = Display.find(params[:id])
  end
end
