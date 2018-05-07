class CategoriesController < ApplicationController
  before_action :set_category, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Category
    @q          = Category.ransack(params[:q])
    @q.sorts    = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @categories = @q.result(disinct: true)
    set_index_render
  end

  def show
    authorize @category
  end

  def new
    authorize Category
    @category = Category.new
    set_new_edit_render
  end

  def edit
    authorize @category
    set_new_edit_render
  end

  def create
    authorize Category
    @category = Category.new(permitted_attributes(Category))    # Not the final implementation!
    if @category.save
      redirect_to categories_path
    else
      render 'new'
    end
  end

  def update
    authorize @category
    if @category.update_attributes(permitted_attributes(@category))
      redirect_to categories_path
    else
      render 'edit'
    end
  end

  def destroy
    authorize @category
    if @category.destroy
      flash[:success] = "Запись удачно удален."
    else
      flash[:error] = "Запись не может буть удален. Есть связанные данные"
    end
    redirect_to categories_path
  end


  private

  def set_category
    @category = Category.find(params[:id])
  end

  def set_index_render
    render partial: "catalog/catalog_list",
            locals: { q: @q,
                      title: t('.caption_title'),
                      caption_button: t('.caption_button'),
                     main_collection: @categories,
                     new_path: new_category_path }
  end

  def set_new_edit_render
    render partial: 'catalog/catalog_new_edit',
           locals: { title: t('.caption_text'),
           catalog_name: @category,
           index_path: categories_path }
  end


end
