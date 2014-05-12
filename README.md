# ActiveRecordPatchFirstOrCreate

Real atomic first_or_create/find_or_create_by for Rails

## Installation

Add this line to your application's Gemfile:

    gem 'active_record_patch_first_or_create'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record_patch_first_or_create

## Solution

We find out that methods like first_or_create or find_or_create_by are not atomic, you can check docs here

"Please note *this method is not atomic*, it runs first a SELECT, and if there are no results an INSERT is attempted. If there are other threads or processes there is a race condition between both calls and it could be the case that you end up with two similar records."

## Usage

Finds the first record with the given attributes, or creates a record with the attributes if one is not found:

# Find the first user with uid "abc123" or create a new one.
User.where(uid: 'abc123').atomic_first_or_create(name: 'John', uid: 'abc123')
# => #<User id: 1, uid: "abc123", name: 'John'>

# Find the first user with uid "abc123" or create a new one.
# We already have one so the existing record will be returned.
User.where(uid: 'abc123').atomic_first_or_create(name: 'John', uid: 'abc123')
# => #<User id: 1, uid: "abc123", name: 'John'>

# Find the first user with uid "abc1234" or create a new one
User.where(uid: 'abc123').atomic_first_or_create(name: 'Johansson', uid: 'abc1234')
# => #<User id: 2, uid: "abc1234", name: 'Johansson'>
