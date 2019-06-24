class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
    name_tabl = self.class.name.split('Policy').join.titleize.split.join('_').downcase
    @access_record =
      @user.template_roles.where("resource_names.table_name = ?",
        name_tabl).joins(action_name: :resource_name)
  end

  def index?
    access_type?('index') || user.super_admin?
  end

  def show?
    scope.where(id: record.id).exists?
    access_type?('show') || user.super_admin?
  end

  def create?
    access_type?('new') || user.super_admin?
  end

  def new?
    create?

  end

  def update?
    access_type?('edit') || user.super_admin?
  end

  def edit?
    update?
  end

  def destroy?
    (access_type?('destroy') || user.super_admin?) &&  record.can_destroy?
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

  private

  def access_type?(action_name)
    type_access = @access_record.where("action_apps.action_app_name = ?", action_name).
                  joins(action_name: :action_app).pluck(:type_access)
    #binding.pry
    if type_access.present?
      if (type_access.join == 'allowed_all') ||
         (type_access.join == 'allowed_current')
         return true
      else
        return false
      end
    else
      return false
    end
  end
end
