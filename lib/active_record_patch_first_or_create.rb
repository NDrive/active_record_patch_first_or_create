require "active_record_patch_first_or_create/version"

module ActiveRecordPatchFirstOrCreate
  def self.first_or_create relation, attributes
    attributes = attributes.merge(relation.where_values_hash)
    attributes = attributes.merge(rails_timestamps) if relation.klass.record_timestamps?

    sql = "INSERT INTO #{relation.table_name} (#{attributes.keys.join(",")})
           SELECT #{(['?'] * attributes.values.count).join(', ')}
           WHERE NOT EXISTS (#{relation.select('1').to_sql})"

    relation.klass.find_by_sql([sql] + attributes.values)

    relation.first
  end

  def self.rails_timestamps
    time = Time.now
    { created_at: time, updated_at: time }
  end
end

module ActiveRecord
  class Relation
    def atomic_first_or_create(attributes = nil, &block)
      ActiveRecordPatchFirstOrCreate.first_or_create(self, attributes)
    end
  end
end
