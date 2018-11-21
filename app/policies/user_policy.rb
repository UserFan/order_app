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
    user.super_admin? ||
    user.moderator? && !record.super_admin? || user == record
  end

  def system_user?
    user.super_admin? || user.moderator?
  end

  def destroy?
    return false if user == record
    return false if user.moderator? && record.super_admin?
    return false if user.user? || user.guide?
    true
  end

  def permitted_attributes
    #binding.pry
    #if (user.super_admin? || user.moderator?)
      [:email,
        profile_attributes: [:id, :user_id, :surname, :first_name,
                             :middle_name, :avatar, :mobile, :date_recruitment,
                             :date_quit]]
    # elsif user == record && !user.super_admin? && !user.moderator? && record.locked_at.nil?
    #   [:password, :password_confirmation, profile_attributes: []]

    # if user == record && (user.super_admin? || user.moderator?)
    #   [:email, :password, :password_confirmation, :remember_me,
    #    profile_attributes: [:id, :user_id, :position_id, :surname, :first_name,
    #                         :middle_name, :avatar, :mobile]]
    # elsif user == record && !user.super_admin? && !user.moderator?
    #   [:password, :password_confirmation, :remember_me,
    #    profile_attributes: [:id, :user_id, :position_id, :surname, :first_name,
    #                         :middle_name, :avatar, :mobile]]
    # elsif user.super_admin? || user.moderator?
    #   [:role_id, :email, :password, :password_confirmation, :remember_me,
    #    profile_attributes: [:id, :user_id, :position_id, :surname, :first_name,
    #                         :middle_name, :avatar, :mobile]]
    #end
  end
end
