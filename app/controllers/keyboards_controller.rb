class KeyboardsController < ApplicationController
  before_action :set_keyboard, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Keyboard
    @q = Keyboard.ransack(params[:q])
    @q.sorts = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @keyboards = @q.result(disinct: true)
    set_index_render
  end

  def show
    authorize @keyboard
  end

  def new
    authorize Keyboard
    @keyboard = Keyboard.new
    set_new_edit_render
  end

  def edit
    authorize @keyboard
    set_new_edit_render
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

  def set_keyboard
    @keyboard = Keyboard.find(params[:id])
  end

  def set_index_render
    render partial: "catalog/catalog_list",
            locals: { q: @q,
                      title: t('.caption_title'),
                      caption_button: t('.caption_button'),
                      main_collection:@keyboards,
                      new_path: new_keyboard_path }
  end

  def set_new_edit_render
    render partial: 'catalog/catalog_new_edit',
           locals: { title: t('.caption_text'),
           catalog_name: @keyboard,
           index_path: keyboards_path }
  end
end
