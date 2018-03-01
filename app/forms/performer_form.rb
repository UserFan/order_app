require "reform/form/coercion"

class PerformerForm < Reform::Form
  feature Coercion

  include Reform::Form::ActiveModel
  include Reform::Form::ActiveModel::ModelReflections
  model :performer
  # collection :performers, prepopulator: :build_performer,
  #                         populator: :performer_populator do

  property :user_id
  property :date_performance, type: Types::Form::DateTime
  property :date_close_performance, type: Types::Form::DateTime
  property :coexecutor
  property :message
  property :comment
  property :_destroy, virtual: true
  #end

  # def build_performer(*)
  #   performers << Performer.new if performers.blank?
  # end
  #
  # def performer_populator(fragment:, collection:, **)
  #   performer = collection.find_by(id: fragment['id']) unless fragment['id'].blank?
  #   if fragment['_destroy'] == '1'
  #     collection.delete(performer)
  #     return skip!
  #   else
  #     performer ? performer : collection.append(Performer.new)
  #   end
  # end


end
