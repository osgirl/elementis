module Elementis
  module ElementBuilder
    def element(name, *args)
      define_method "#{name}" do
        Element.new(name, *args)
      end
    end
  end
end
