$LOAD_PATH << '.'

require 'json'
require 'Building'
require 'Style'
require 'DiagramExport'

module Architech

  class Architech
    attr_accessor :style_lib

    def initialize
      @style_lib = StyleLibrary.new self

      @b = Building.new(self)
      make_style_diagram @b
    end
  end

  class BuildingGraph
    attr_accessor :nodes
  end

  class Node
    attr_accessor :horizontal, :above, :below

    def initialize(parent = nil)
      @below = parent
    end
  end

  if $0 == __FILE__
    a = Architech.new
  end
end
