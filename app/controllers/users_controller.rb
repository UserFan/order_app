class UsersController < ApplicationController
  before_action :set_user, except: [ :index, :new, :create, :system_user, :access_list, :close_user_access ]
  before_action :set_open_user_access, only: [ :edit_open_user_access, :open_user_access, :close_access]
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
    generated_password = '123456'
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

  def access_list
    authorize User
    #@q = User.includes(:profile).where('locked_at is not null and admin = false').search(params[:q])
    @q = User.includes(:profile).where.not(admin: true, locked_at: nil).search(params[:q])
    @q.sorts = ['surname asc', 'created_at desc'] if @q.sorts.empty?
    @users_for_access = @q.result(disinct: true)
  end

  def edit_open_user_access
    authorize @user_open_access
  end

  def close_access
    authorize @user_open_access
    if @user_open_access.update_without_password(locked_at: DateTime.now)
      redirect_to system_user_path
      flash[:success] = "Пользователю доступ к системе закрыт."
    else
      redirect_to system_user_path
      flash[:error] = "Доступ пользователю не закрыт. Обратитесь к разработчику!!!"
    end
  end

  def open_user_access
    authorize @user_open_access
    password = permitted_attributes(@user_open_access)[:password]
    password_confirmation = permitted_attributes(@user_open_access)[:password_confirmation]
    unless @user_open_access.reset_password(password, password_confirmation)
      render 'edit_open_user_access'
    else
      if @user_open_access.update_without_password(permitted_attributes(@user_open_access).merge(locked_at: nil))
        redirect_to system_user_path
      else
        render 'edit_open_user_access'
      end
    end
  end


  private

  def set_user
    @user = User.includes(:profile).find(params[:id])
  end

  def set_open_user_access
    @user_open_access = User.includes(:profile).find(params[:id])
  end
end
