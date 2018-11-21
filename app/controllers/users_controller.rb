class UsersController < ApplicationController
  before_action :set_user, except: [ :index, :new, :create, :system_user ]
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize User
    @q = User.includes(:profile).where(admin: false).search(params[:q])
    @q.sorts = ['surname asc', 'created_at desc'] if @q.sorts.empty?
    @users = @q.result(disinct: true)
  end

  def new
    authorize User
    #@user = User.new(password: 'UserBlock', password_confirmation: 'UserBlock', locked_at: DateTime.now)
    @user = User.new
    @user.build_profile
  end

  def show
    authorize @user
  end

  def edit
    authorize @user
  end

  def create
    generated_password = Devise.friendly_token.first(15)
    @user = User.new(permitted_attributes(User).merge(password: generated_password))    # Not the final implementation!
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

  def system_user
    authorize User
    @q = User.includes(:profile).where('locked_at is null and admin = false').search(params[:q])
    @q.sorts = ['surname asc', 'created_at desc'] if @q.sorts.empty?
    @system_user = @q.result(disinct: true)
  end

  def user_system_edit

  end


  private

  def set_user
    @user = User.includes(:profile).find(params[:id])
  end
end
