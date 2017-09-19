class UsersController < ApplicationController

  before_action :set_user, except: [ :index, :new, :create ]
  #before_action :user_super_admin, only: [ :edit, :update, :destroy ]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize User
    @users = User.all    
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
     redirect_to users_path
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

  def user_params
    params.require(:user).permit([:full_name, :position, :role, :mobile, :email, :password,
                    :password_confirmation, :remember_me])
  end

  def set_user
    @user = User.find(params[:id])
  end
end
