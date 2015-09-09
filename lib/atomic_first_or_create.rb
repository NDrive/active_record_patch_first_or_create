require "atomic_first_or_create/version"

module ActiveRecord
  class Relation
    def atomic_first_or_create(**opts)
      # We do not want to retry forever to avoid getting stuck

      tries = 2
      begin
        first_or_create **opts
      rescue ActiveRecord::RecordNotUnique
        tries -= 1
        if tries.zero?
          raise
        end

        retry
      end
    end
  end
end
