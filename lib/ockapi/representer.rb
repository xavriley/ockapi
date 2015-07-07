module Ockapi
  class Representer

    def initialize(options={})
      @type   = options.fetch(:type)
      @value  = options.fetch(:value)
      @parent = options.fetch(:parent, nil)
    end

    def represent
      collection.map { |item|
        if item.is_a? Array
          item.map {|i|
            if i.is_a? Hash
              definition_class.new(i, @parent)
            else
              i
            end
          }
        elsif item.is_a? Hash
          if(item.length == 0)
            nil
          elsif(item.length == 1 and item.values.first.is_a?(Hash))
            definition_class.new(item.values.first, @parent)
          else
            definition_class.new(item, @parent)
          end
        else
          item
        end
      }.flatten.compact
    end

    private

    def collection
      if @value.is_a? Hash
        @collection ||= [].push @value
      else
        @collection ||= Array(@value)
      end
    end

    def definition_class
      Ockapi.const_get(class_string)
    rescue NameError
      Object.const_set(class_string, Representation)
    end

    def class_string
      if @type == "data"
        "Datum"
      else
        @type.gsub(/s\z/,'').capitalize.gsub(/\s/, '')
      end
    end
  end
end
