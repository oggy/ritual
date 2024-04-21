module Ritual
  VERSION = [0, 5, 1]

  class << VERSION
    include Comparable

    def to_s
      join('.')
    end
  end
end
