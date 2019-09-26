class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
    name_tabl = self.class.name.split('Policy').join.titleize.split.join('_').downcase
    @access_record =
      @user.template_accesses.where("enum_resources.resource_name = ?", name_tabl)
    #binding.pry
  end

  def index?
    access_all?('index') || access_only?('index') || user.super_admin?
  end

  def show?
    scope.where(id: record.id).exists?
    access_all?('show') || user.super_admin?
  end

  def create?
    access_all?('new') || user.super_admin?
  end

  def new?
    create?
  end

  def update?
    access_all?('edit') || user.super_admin?
  end

  def edit?
    update?
  end

  def destroy?
    (access_all?('destroy') || user.super_admin?) && record.can_destroy?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
      name_tabl = @scope.name.titleize.split.join('_').downcase
      @access_record =
        @user.template_accesses.where("enum_resources.resource_name = ?", name_tabl)
    end

    def resolve
      scope
    end

    private

    def access_set(action_name)
      type_access = @access_record.where("enum_actions.action_name = ?", action_name).
                    joins(action_name: :action_app).pluck(:type_access)

      type_access.join if type_access.present?
    end
  end

  private

  def access_all?(action_name)
    access_set(action_name) == 'allowed_all'
  end

  def access_only?(action_name)
    access_set(action_name) == 'allowed_current'
  end

  def access_set(action_name)
    type_access = @access_record.where("action_apps.action_app_name = ?", action_name).
                  joins(action_name: :action_app).pluck(:type_access)

    type_access.join if type_access.present?
  end

end
