module ActiveRecordPatchFirstOrCreate
  class ArelQueryCreator < Struct.new(:relation, :attributes)
    def to_sql
      insert_query.to_sql
    end

    private

    def insert_query
      manager = Arel::InsertManager.new(ActiveRecord::Base)
      manager.into table

      attributes.keys.each do |name|
        manager.columns << table[name]
      end

      manager.select select_query
      manager
    end

    def select_query
      select = Arel::SelectManager.new(ActiveRecord::Base)
      attributes.values.each do |value|
        select.project Arel.sql(ActiveRecord::Base.connection.quote(value))
      end
      select.where(not_exists_query.exists.not)
      select
    end

    def not_exists_query
      query = table.project(Arel.sql('1'))
      relation.where_values_hash.each do |k,v|
        query.where(table[k.to_sym].eq(v))
      end
      query
    end

    def table
      Arel::Table.new relation.table_name
    end
  end
end