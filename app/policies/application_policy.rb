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

  # def index?(shop=nil)
  #   return true if user.super_admin? || access_all?('default')
  #
  #   return true if shop.present? && ((access_read?('default') || access_write?('default')) &&
  #                  user.current_shops.include?(shop))
  #   return true if shop.nil? && (access_read?('default') || access_write?('default'))
  #
  #   binding.pry
  # end

  def index?
    user.super_admin? || access_all?('default') ||
    access_read?('default') || access_write?('default')
  end

  def show?
    scope.where(id: record.id).exists?
    index?
    # access_all?('default') || access_read?('default') ||
    # access_write?('default') || user.super_admin?
  end

  def create?
    new?
  end

  def new?
    access_all?('default') ||  user.super_admin? || access_write?('default')
  end

  def update?
    new?
  end

  def edit?
    update?
  end

  def destroy?
    (user.super_admin?) && record.can_destroy?
  end

  def link_view?(shop)
    user.super_admin? || access_all?('default') ||
    ((access_read?('default') || access_write?('default')) &&
     user.current_shops.include?(shop))
  end

  def view_menu?
    user.super_admin? || !access_not?('default')
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
