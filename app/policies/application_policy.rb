class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
    name_tabl = self.class.name.split('Policy').join.titleize.split.join('_').downcase
    @access_record =
      @user.template_accesses.where(enum_resources: { resource_name: name_tabl }).
            includes(:enum_resource)
    #binding.pry
  end

  def index?
    access_all?('default') || access_read?('default') || user.super_admin?
  end

  def show?
    scope.where(id: record.id).exists?
    access_all?('default') || access_read?('default') || user.super_admin?
  end

  def create?
    access_all?('default') || access_write?('default') || user.super_admin?
  end

  def new?
    create?
  end

  def update?
    access_all?('default') || access_write?('default') || user.super_admin?
  end

  def edit?
    update?
  end

  def destroy?
    (user.super_admin?) && record.can_destroy?
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
        @user.template_accesses.where(enum_resources: { resource_name: name_tabl }).
                                      includes(:enum_resource)
    end

    def resolve
      scope
    end

    private

    def access_set(action_name)
      type_access = @access_record.where(enum_actions: { action_name: action_name }).
                    joins(enum_resource: :enum_action).pluck(:enum_type_access_id)

      type_access.join.to_i if type_access.present?
    end
  end

  private

  def access_set(action_name)
    type_access = @access_record.where(enum_actions: { action_name: action_name }).
                  joins(enum_resource: :enum_action).pluck(:enum_type_access_id)

    type_access.join.to_i if type_access.present?
  end

  def access_all?(action_name)
    access_set(action_name) == EnumTypeAccess::ALLALOWED
  end

  def access_read?(action_name)
    access_set(action_name) == EnumTypeAccess::READONLY
  end

  def access_write?(action_name)
    access_set(action_name) == EnumTypeAccess::READWRITEONLY
  end

  def access_not?(action_name)
    access_set(action_name) == EnumTypeAccess::NOTALLOWED
  end

end
