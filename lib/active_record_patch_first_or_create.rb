require "active_record_patch_first_or_create/version"
require "active_record_patch_first_or_create/arel_query_creator"

module ActiveRecordPatchFirstOrCreate
  def self.first_or_create relation, attributes

    attributes = attributes.merge(relation.where_values_hash)
    attributes = attributes.merge(rails_timestamps(relation))
    attributes = serialize_columns(relation, attributes)

    ActiveRecord::Base.connection.execute(ArelQueryCreator.new(relation, attributes).to_sql)

    relation.first
  end

  def self.rails_timestamps relation
    time = Time.now
    { created_at: time, updated_at: time }.keep_if { |key| relation.klass.column_names.include?(key.to_s) }
  end

  def self.serialize_columns relation, attributes
    Hash[attributes.map do |key, value|
      column = relation.klass.columns.find { |c| c.name == key.to_s }
      [key, column ? column.cast_type.type_cast_for_database(value) : value]
    end]
  end
end

module ActiveRecord
  class Relation
    def atomic_first_or_create(attributes = nil)
      ActiveRecordPatchFirstOrCreate.first_or_create(self, attributes)
    end
  end
end