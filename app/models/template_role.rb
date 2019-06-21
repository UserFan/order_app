class TemplateRole < ApplicationRecord
  belongs_to :role
  belongs_to :action_name
  has_many :users, through: :role, foreign_key: :role_id
  has_one :resource_name, through: :action_name, foreign_key: :resource_name_id
  enum type_access: { allowed_all: 100, allowed_current: 101,
                      not_allowed: 200 }, _prefix: :access

  delegate_missing_to :resource_name
  delegate_missing_to :action_name
  validates :name, :type_access, :action_name_id, :role_id, presence: true

  def self.i18n_access(hash = {})
    type_accesses.keys.each { |key| hash[I18n.t("enum.type_access.#{key}")] = key }
    hash
  end

  def t_enum(enum)
    I18n.t "activerecord.attributes.#{self.class.name.underscore}.enums.#{enum}.#{self.send(enum)}"
  end

end
