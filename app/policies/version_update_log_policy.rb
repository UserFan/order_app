class VersionUpdateLogPolicy < ApplicationPolicy

  def index?
    user.super_admin?
  end

  def show?
    index?
  end

  def create?
    index?
  end

  def new?
    index?
  end

  def update?
    index?
  end

  def edit?
    index?
  end

  def destroy?
    index?
  end

  def permitted_attributes
    [:shop_id, :date_log, :text_log, :result_update] if user.super_admin? || (access_type?('edit') || access_type?('new'))
  end

end
