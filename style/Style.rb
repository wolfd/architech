module Architech

  class Style
    attr_accessor :name, :description

    def initialize(architech, name)
      @architech = architech
      @name = name
    end

    def make

    end

    def to_s
      "#{@name}"
    end

  end

  class ConcreteStyle < Style
    def initialize(architech, name)
      super(architech, name)
    end

    def make
      super
      {}
    end
  end

  class AbstractStyle < Style
    attr_reader :name, :substyles

    def initialize(architech, name, substyles)
      super(architech, name)
      begin
        @substyles = substyles

      rescue Exception => e
        puts "failed to find AbstractStyle #{name}"
        puts e.message
        puts e.backtrace.inspect
        raise Exception, 'Failed to find AbstractStyle. Cannot continue.'
      end
    end

    def make
      super
      decompose
    end

    private

    def decompose
      return_tree = {}

      @substyles.each { |style|
        if style['chance'].to_f > Random.rand
          begin
            return_tree[style['name']] = @architech.style_lib.styles[style['name']].make
          rescue Exception => e
            puts "No style named #{style['name']}. Check #{name}"
            puts e.message
            puts e.backtrace.inspect
          end
        end
      }
      return_tree
    end
  end

  class StyleLibrary

    attr_reader :styles

    ##
    # Loads every style in the 'styles' folder
    def initialize(architech)
      @architech = architech
      @styles = {}
      load_style 'styles'
    end

    private
    ##
    # Loads a style or directory of styles
    def load_style(name)
      if File.directory? name
        (Dir.glob "#{name}/*").each { |recursive_name| load_style recursive_name }
      elsif File.file?(name) && name.end_with?('.json')
        load_abstract_style name
      elsif File.file?(name) && name.end_with?('.rb')
        load_concrete_style name
      end
    end

    def load_abstract_style(name)
      begin
        parsed = JSON.parse(File.read name)
        if parsed.kind_of? Array
          parsed.each { |sty|
            @styles[sty['name']] = AbstractStyle.new(@architech, sty['name'], sty['substyles'])

            puts "loaded #{sty['name']}"
          }
        else
          @styles[parsed['name']] = AbstractStyle.new(@architech, parsed['name'], parsed['substyles'])

          puts "loaded #{parsed['name']}"
        end

      rescue Exception => e
        puts "failed to load #{name}"
        puts e.message
        puts e.backtrace.inspect
      end
    end

    def load_concrete_style(name)
      begin
        require File.expand_path(name.chomp('.rb'))
        simple_name = File.basename(name, '.rb')
        @styles[simple_name] = Object.const_get('ArchitechStyle').const_get(simple_name).new(@architech, simple_name)
        puts "loaded #{simple_name}"
      rescue Exception => e
        puts "failed to load #{name}"
        puts e.message
        puts e.backtrace.inspect
      end
    end
  end
end