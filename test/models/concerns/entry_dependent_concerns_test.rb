require 'test_helper'

class EntryDependentConcernsExample
  extend ActiveModel::Callbacks
  define_model_callbacks :destroy

  include EntryDependentConcerns

  attr_accessor :entries
  attr_reader :errors

  def initialize(entries = [])
    @errors = ActiveModel::Errors.new(self)
    @entries = entries
  end

  def destroy
    run_callbacks :destroy do
    end
  end
end

class EntryDependentConcernsTest < ActiveSupport::TestCase
  setup do
    @with_entries = EntryDependentConcernsExample.new([1,2,3])
    @without_entries = EntryDependentConcernsExample.new()
  end

  test "should have a deletable method" do
    assert @with_entries.respond_to?(:deletable?)
  end

  test "should not allow deletion unless entries are empty" do
    assert !@with_entries.deletable?, "was marked as deletable when it had entries"
  end

  test "should allow deletion if entries are empty" do
    assert @without_entries.deletable?, "was not marked as deletable when it had no entries"
  end

  test "check_for_entries should return false if entries are present" do
    assert !@with_entries.check_for_entries, "check_for_entries did not return false"
  end

  test "should add error to base if entries are present" do
    @with_entries.destroy
    assert @with_entries.errors[:base].include?("Could not delete, belongs to one or more catalog records"), "Could not find error message"
  end
end
