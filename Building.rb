module Architech
  class Building
    attr_accessor :name, :graph, :lot, :styleset

    def initialize(architech, name = "Default", starting_style = "Early 20th Century")
      @architech = architech
      @name = name
      @starting_style = @architech.style_lib.styles[starting_style]

      generate
    end

    def generate
      decompose_styles
      generate_building_graph
      generate_basic_geometry
      generate_facade
      generate_interior
      puts 'finished generation'
    end

    private

    def decompose_styles
      if @starting_style.instance_of? AbstractStyle
        @styleset = {@starting_style.name => @starting_style.make}
      end
    end

    def generate_building_graph

    end

    def generate_basic_geometry
      # for later
    end

    def generate_facade
      # for later
    end

    def generate_interior
      # for later
    end

    # begin
  end
end