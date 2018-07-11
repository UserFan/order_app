class UsersController < ApplicationController
  before_action :set_user, except: [ :index, :new, :create ]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize User
    @q = User.where(admin: false).ransack(params[:q])
    @q.sorts = ['full_name asc', 'created_at desc'] if @q.sorts.empty?
    @users = @q.result(disinct: true)
  end

  def new
    authorize User
    @user = User.new
  end

  def show
    authorize @user
  end

  def edit
    authorize @user
  end

  def create
    @user = User.new(permitted_attributes(User))    # Not the final implementation!
    authorize @user
    if @user.save
      redirect_to users_path
    else
      render 'new'
    end
  end

  def update
    authorize @user
    if @user.update_without_password(permitted_attributes(@user))
      if current_user.moderator? || current_user.super_admin?
        redirect_to users_path
      else
        redirect_to root_path
      end
    else
      render 'edit'
    end
  end

  def destroy
    authorize @user
    if @user.destroy
      flash[:success] = "Пользователь удачно удален."
      redirect_to users_path
    else
      flash[:error] = "Пользователь не может буть удален. Есть связанные данные"
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
  end
end
