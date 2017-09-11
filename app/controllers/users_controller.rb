class UsersController < ApplicationController

  before_action :set_user, except: [ :index, :new, :create ]
  #before_action :user_super_admin, only: [ :edit, :update, :destroy ]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    @users = User.all
    authorize User
  end

  def new
    @user = User.new
    authorize User
  end

  def show
    authorize @user
  end

  def edit
    authorize @user
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
    authorize @user
    if @user.save
      redirect_to users_path
    else
      render 'new'
    end
  end

  def update
    authorize @user
    if @user.update_without_password(user_params)
     redirect_to users_path
    else
    #  redirect_to root_path
    #   end
    # else
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

  def user_params
    added_attrs = [:full_name, :position, :role, :mobile, :email, :password, :password_confirmation, :remember_me]
    params.require(:user).permit (added_attrs)
  end

  def set_user
      @user = User.find(params[:id])
  end

  # def user_super_admin
  #   if @user.super_admin? and !current_user.super_admin?
  #     flash[:error] = "Данную запись нельзя редактировать"
  #     redirect_to request.referrer
  #   end
  # end
end
