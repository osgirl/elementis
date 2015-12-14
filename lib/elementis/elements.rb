module Elementis
  class Elements
    include Enumerable

    def initialize(*args)
      @elements = nil
      @agrs = args
    end

    def elements
      @elements = all(*args).map {|e| Element.new(*args).element = e} unless @elements.nil?
      @elements
    end

    def each(&block)
      elements.each { |e| block.call(e) }
    end
  end
end