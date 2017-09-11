class UserPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def new?
    @current_user.admin? || @current_user.super_admin?
  end

  def index?
    return false if @current_user == @user
    @current_user.admin? || @current_user.super_admin?
  end

  def create?
    @current_user.admin? || @current_user.super_admin?
  end

  def show?
    @current_user.admin? || @current_user.super_admin? or @current_user == @user
  end

  def update?
    edit?
  end

  def edit?
    # binding.pry
    @current_user.super_admin? ||
    @current_user.admin? && !@user.super_admin? ||
    @current_user == @user
  end

  def destroy?
    return false if @current_user == @user
    return false if @current_user.admin? && @user.super_admin?
    return false if @current_user.user? || @current_user.vip?
    true
  end

end
