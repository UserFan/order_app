class UserPolicy < ApplicationPolicy

  def new?
    user.super_admin?

  end

  def index?
    #binding.pry
    return false if user == record
    user.super_admin?
  end

  def create?
     user.super_admin?

  end

  def show?
   user.super_admin? or user == record
  end

  def update?
    edit?
  end

  def edit?
    user.super_admin? || user == record
  end

  def system_user?
    user.super_admin?
  end

  def access_list?
    system_user?
  end

  def open_user_access?
    system_user?
    @@open_access = true
  end

  def edit_open_user_access?
    system_user?
    @@open_access = true
  end

  def close_access?
    system_user?
  end

  def destroy?
    # return false if user == record
    # return false if user.moderator? && record.super_admin?
    # return false if user.user? || user.guide?
    # return false unless record.can_destroy?
    # true
    user.super_admin?
  end

  def permitted_attributes
    @@open_access ||= false
    #binding.pry
    if (user.super_admin? || user.moderator?) && !(@@open_access)
      [:email,
        profile_attributes: [:id, :user_id, :surname, :first_name,
                             :middle_name, :avatar, :mobile, :date_recruitment,
                             :date_quit]]
    elsif @@open_access && (user.super_admin? || user.moderator?)
      [:email, :password, :password_confirmation, :role_id]
    end
  end
end
