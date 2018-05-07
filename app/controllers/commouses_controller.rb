class CommousesController < ApplicationController
  before_action :set_commouse, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Commouse
    @q = Commouse.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @commouses = @q.result(disinct: true)
    set_index_render
  end

  def show
    authorize @commouse
  end

  def new
    authorize Commouse
    @commouse = Commouse.new
    set_new_edit_render
  end

  def edit
    authorize @commouse
    set_new_edit_render
  end

  def create
    authorize Commouse
    @commouse = Commouse.new(permitted_attributes(Commouse))    # Not the final implementation!
    if @commouse.save
      redirect_to commouses_path
    else
      render 'new'
    end
  end

  def update
    authorize @commouse
    if @commouse.update_attributes(permitted_attributes(@commouse))
     redirect_to commouses_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @commouse
    if @commouse.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to commouses_path
  end


  private

  def set_commouse
    @commouse = Commouse.find(params[:id])
  end

  def set_index_render
    render partial: "catalog/catalog_list",
            locals: { q: @q,
                      title: t('.caption_title'),
                      caption_button: t('.caption_button'),
                      main_collection: @commouses,
                      new_path: new_commouse_path }
  end

  def set_new_edit_render
    render partial: 'catalog/catalog_new_edit',
           locals: { title: t('.caption_text'),
           catalog_name: @commouse,
           index_path: commouses_path }
  end
end
