module Elementis
  module ElementBuilder
    def element(name, *args)
      define_method "#{name}" do
        Element.new(name, *args)
      end
    end

    # TODO: Build me
    def elements(_name, *_args)

    end
  end
end