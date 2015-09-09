require 'test_helper'
require 'atomic_first_or_create'

class AtomicTest < MiniTest::Test
  def teardown
    Person.delete_all
  end

  def test_creation
    p = Person.where(first_name: 'Hugo', last_name: 'Peixoto').atomic_first_or_create

    assert_equal ['Hugo', 'Peixoto'], [p.first_name, p.last_name]
  end

  def test_return_existing
    p1 = Person.where(first_name: 'Hugo', last_name: 'Peixoto').atomic_first_or_create
    p2 = Person.where(first_name: 'Hugo', last_name: 'Peixoto').atomic_first_or_create

    assert_equal p1, p2
  end

  def test_creation_with_extra_args
    p = Person.where(first_name: 'Hugo', last_name: 'Peixoto').atomic_first_or_create age: 28

    assert_equal 28, p.age
  end

  def test_return_with_extra_args
    Person.where(first_name: 'Hugo', last_name: 'Peixoto').atomic_first_or_create age: 28

    p2 = Person.where(first_name: 'Hugo', last_name: 'Peixoto').atomic_first_or_create age: 52

    assert_equal 28, p2.age
  end
end
