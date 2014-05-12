require "active_record_patch_first_or_create/version"

module ActiveRecordPatchFirstOrCreate
  def self.first_or_create relation, attributes
    attributes = attributes.merge(relation.where_values_hash)
    attributes = attributes.merge(rails_timestamps(relation))
    attributes = serialize_columns(relation, attributes)

    sql = "INSERT INTO #{relation.table_name} (#{attributes.keys.join(",")})
           SELECT #{(['?'] * attributes.values.count).join(', ')}
           WHERE NOT EXISTS (#{relation.select('1').to_sql})"

    relation.klass.find_by_sql([sql] + attributes.values)

    relation.first
  end

  def self.rails_timestamps relation
    time = Time.now
    { created_at: time, updated_at: time }.keep_if { |key| relation.klass.column_names.include?(key.to_s) }
  end

  def self.serialize_columns relation, attributes
    Hash[attributes.map do |key, value|
      serializer = relation.klass.serialized_attributes[key.to_s]
      value = serializer.dump(value) unless serializer.nil?
      [key, value]
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
