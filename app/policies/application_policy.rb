class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
     user.moderator? || user.guide? || user.super_admin?
  end

  def show?
    scope.where(id: record.id).exists?
     user.guide? || user.moderator? || user.super_admin?
  end

  def create?
    user.super_admin? || user.guide?
  end

  def new?
    create?
  end

  def update?
    edit?
  end

  def edit?
     user.guide? || user.super_admin?
  end

  def destroy?
    user.guide? || user.super_admin? &&
    record.can_destroy?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
