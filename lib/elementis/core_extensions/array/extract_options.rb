module Elementis
  module CoreExtensions
    module Array
      module ExtractOptions
        def extract_options!
          last.is_a?(::Hash) ? pop : {}
        end unless defined? [].extract_options!
      end
    end
  end
end
