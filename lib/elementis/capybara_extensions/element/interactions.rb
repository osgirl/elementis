module Elementis
  module CapybaraExtensions
    module Element
      module Interactions
        def set_checked(value)
          if (self.checked? && !value) || (!self.checked? && value)
            self.click
          end
        end
      end
    end
  end
end
