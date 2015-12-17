module Elementis
  module CapybaraExtensions
    module Element
      module Interactions
        def check(value)
          set(value) if (self.checked? && !value) || (!self.checked? && value)
        end
      end
    end
  end
end
