# AtomicFirstOrCreate

ActiveRecord `first_or_create` alternative that retries on RecordNotUnique exception.

`first_or_create` does not guarantee uniqueness by itself, and if there is a
uniqueness constraint on the database, it may fail with a RecordNotUnique
exception.  This gem adds `atomic_first_or_create` to ActiveRecord::Relation,
which, in conjunction with a uniqueness constraint, provides the correct
behaviour.

## Installation

Add this line to your application's Gemfile:

    gem 'atomic_first_or_create'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install atomic_first_or_create

## Solution

As documented by the rails team, methods like `first_or_create` or
`find_or_create` are not atomic:

"Please note *this method is not atomic*, it runs first a SELECT, and if there
are no results an INSERT is attempted. If there are other threads or processes
there is a race condition between both calls and it could be the case that you
end up with two similar records."

The documentation suggests using a UNIQUE constraint on the rows which you wish
to enforce uniqueness, and retrying when the query raises the exception
`ActiveRecord::RecordNotUnique`. This gem provides a method
`atomic_first_or_create` which does exactly that.

## Usage

Finds the first record with the given attributes, or creates a record with the attributes if one is not found:

```ruby
# Find the first user with uid "abc123" or create a new one.
User.where(uid: 'abc123').atomic_first_or_create(name: 'John', uid: 'abc123')
# => #<User id: 1, uid: "abc123", name: 'John'>
```
```ruby
# Find the first user with uid "abc123" or create a new one.
# We already have one so the existing record will be returned.
User.where(uid: 'abc123').atomic_first_or_create(name: 'John', uid: 'abc123')
# => #<User id: 1, uid: "abc123", name: 'John'>
```
```ruby
# Find the first user with uid "abc1234" or create a new one
User.where(uid: 'abc123').atomic_first_or_create(name: 'Johansson', uid: 'abc1234')
# => #<User id: 2, uid: "abc1234", name: 'Johansson'>
```
