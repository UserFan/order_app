class UserPolicy < ApplicationPolicy

  def new?
    user.moderator? || user.super_admin?
  end

  def index?
    #binding.pry
    return false if user == record
    user.moderator? || user.super_admin?
  end

  def create?
    user.moderator? || user.super_admin?
  end

  def show?
    user.moderator? || user.super_admin? or user == record
  end

  def update?
    edit?
  end

  def edit?
    # binding.pry
    user.super_admin? ||
    user.moderator? && !record.super_admin? || user == record
  end

  def destroy?
    return false if user == record
    return false if user.moderator? && record.super_admin?
    return false if user.user? || user.guide?
    true
  end

  def permitted_attributes
    if user == record && (user.super_admin? || user.moderator?)
      [:full_name, :position_id, :mobile, :email, :password,
        :password_confirmation, :remember_me]
    elsif user == record && !user.super_admin? && !user.moderator?
      [:full_name, :mobile, :password, :password_confirmation, :remember_me]
    elsif user.super_admin? || user.moderator?
      [:full_name, :position_id, :role_id, :mobile, :email, :password,
        :password_confirmation, :remember_me]
    end
  end
end
