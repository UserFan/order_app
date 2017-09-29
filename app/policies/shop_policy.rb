class ShopPolicy < ApplicationPolicy

  def index?
    #binding.pry
    user.moderator? || user.super_admin?

  end

  def new?
    user.moderator? || user.super_admin?

  end

  def create?
    user.moderator? || user.super_admin?

  end

  def edit?
    index?

  end

  def update?
    edit?

  end

  def show?
    index?
  end

  def destroy?
    index?
  end

  def permitted_attributes
    [:name, :address, :gps, :type_id, :photo, :user_id] if user.super_admin? || user.moderator?
  end

end
