class ApcsController < ApplicationController
  before_action :set_apc, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Apc
    @q = Apc.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @apcs = @q.result(disinct: true)
    set_index_render
  end

  def show
    authorize @apc
  end

  def new
    authorize Apc
    @apc = Apc.new
    set_new_edit_render
  end

  def edit
    authorize @apc
    set_new_edit_render
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

  def set_index_render
    render partial: "catalog/catalog_list",
            locals: { q: @q,
                      title: t('.caption_title'),
                      caption_button: t('.caption_button'),
                      main_collection: @apcs,
                      new_path: new_apc_path }
  end

  def set_new_edit_render
    render partial: 'catalog/catalog_new_edit',
           locals: { title: t('.caption_text'),
           catalog_name: @apc,
           index_path: apcs_path }
  end
end
