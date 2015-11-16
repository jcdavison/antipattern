module ObjHelper
  def save_and_associate opts
    created_objs = opts[:objects].inject([]) do |collection, obj|
      obj_attributes = opts[:attributes].inject({}) do |attr_map, attribute|
        attr_map[attribute] = eval("obj[:#{attribute}]")
        attr_map
      end
      new_obj = eval("#{opts[:class]}.find_or_create_by(opts[:find_key] => #{obj_attributes[opts[:find_key]]})")
      new_obj.update_attributes obj_attributes
      parent = opts[:parent]
      association = opts[:class].downcase.pluralize
      eval("parent.send(association) << new_obj")
      obj[:id] = new_obj.id
      collection.push new_obj
    end
    { created_objs: created_objs, input_objs: opts[:objects] }
  end
end
