module EntryDependentConcerns
  extend ActiveSupport::Concern

  included do
    alias_method_chain :deletable?, :entries
    before_destroy :check_for_entries
  end

  unless method_defined?(:deletable?)
    def deletable?
      true
    end
  end

  def deletable_with_entries?
    deletable_without_entries? && entries.empty?
  end

  def published?
    !published_at.nil? && published_at <= Time.now.utc
  end

  def check_for_entries
    return if entries.empty?

    errors.add(:base, 'Could not delete, belongs to one or more catalog records')
    false
  end
end
