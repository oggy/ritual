module Ritual
  VERSION = [0, 2, 1]

  class << VERSION
    include Comparable

    def to_s
      join('.')
    end
  end
end
