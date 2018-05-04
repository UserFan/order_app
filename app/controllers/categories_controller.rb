class CategoriesController < ApplicationController
  layout "catalogs", only: [:index, :new, :edit ]
  before_action :set_category, except: [ :index, :new, :create ]
  after_action :verify_authorized

  def index
    authorize Category
    @q          = Category.ransack(params[:q])
    @q.sorts    = ['name asc', 'created_at desc'] if @q.sorts.empty?
    @categories = @q.result(disinct: true)
  end

  def show
    authorize @category
  end

  def new
    authorize Category
    @category = Category.new
  end

  def edit
    authorize @category
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
end
