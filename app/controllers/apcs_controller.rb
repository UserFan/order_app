class ApcsController < ApplicationController
  before_action :set_apc, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Apc
    @q = Apc.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @apcs = @q.result(disinct: true)
    set_index_render(@q, @apcs, new_apc_path)
  end

  def show
    authorize @apc
  end

  def new
    authorize Apc
    @apc = Apc.new
    set_new_edit_render(@apc, apcs_path)
  end

  def edit
    authorize @apc
    set_new_edit_render(@apc, apcs_path)
  end

  def create
    authorize Apc
    @apc = Apc.new(permitted_attributes(Apc))    # Not the final implementation!
    if @apc.save
      redirect_to apcs_path
    else
      render 'new'
    end
  end

  def update
    authorize @apc
    if @apc.update_attributes(permitted_attributes(@apc))
      redirect_to apcs_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @apc
    if @apc.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to apcs_path
  end


  private

  def set_apc
    @apc = Apc.find(params[:id])
  end
end
