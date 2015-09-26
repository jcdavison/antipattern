module StructuralHelper
  SNAKEREGEXP = /[A-Za-z]+(_[A-Za-z]+)+/
  def structurize_collection stuffs
    stuffs.inject([]) do |bag_of_stuffs, waffle|
      structurize_nodes waffle
      bag_of_stuffs.push structurize_waffle waffle
    end
  end
  
  def structurize_nodes waffle
    waffle.each_pair do |attr, value|
      if value.class == Hash || value.class == Parse::Object
        waffle[attr] = structurize_waffle value
        structurize_nodes waffle[attr]
      end
    end
  end

  def structurize_waffle waff
    OpenStruct.new waff
  end

  def camelize_thing obj
    obj.keys.each do |key|
      value = obj[key]
      if value.class == Hash
        camelize_thing value
      else
        if key.to_s.match SNAKEREGEXP 
          obj[key.to_s.camelize(:lower).to_sym] = value
          obj.delete key
        end
      end
    end
    obj
  end

  def camelize_keys keyed_thing
    keyed_thing.keys.each do |key|
      if key.to_s.match SNAKEREGEXP
        keyed_thing[key.to_s.camelize(:lower).to_sym] = keyed_thing[key]
        keyed_thing.delete key
      end
    end
    keyed_thing
  end
end
