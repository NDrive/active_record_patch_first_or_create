require 'minitest/autorun'
require 'active_record'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :people do |t|
    t.string :first_name
    t.string :last_name
    t.integer :age
  end

  add_index :people, [:first_name, :last_name], unique: true
end

class Person < ActiveRecord::Base
end
