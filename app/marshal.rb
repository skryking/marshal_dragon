module Marshal
  TYPES = [Fixnum, String, TrueClass, FalseClass, Float, Symbol]

  def Marshal.dump(target)
    instance_hash = Hash.new
    instance_hash["type"] = target.class
    
   if Marshal::TYPES.include?(instance_hash["type"])
      instance_hash = target
    elsif target.instance_of?(Array)
      temp = Array.new

      target.each do |item|
        temp << Marshal.dump(item)
      end

      instance_hash["value"] = temp
    elsif target.instance_of?(Hash)
      temp = Hash.new

      target.map do |k, item|
        temp[k] = Marshal.dump(item)
      end

      instance_hash["value"] = temp
    else
      temp = Array.new
       temp_hash = Hash.new
      target.instance_variables.each do |v|
        variable = target.instance_variable_get(v)
        instance_variable_hash = Hash.new
        instance_variable_hash["type"] = variable.class
        instance_variable_hash["name"] = v
        instance_variable_hash["value"] = Marshal.dump(variable)
        temp << instance_variable_hash
      end
      temp_hash["type"] = Array
      temp_hash["name"] = "instance variables"
      temp_hash["value"] = temp
      instance_hash["value"] = temp_hash
    end

    return instance_hash
  end

  def Marshal.load(obj = nil, target)
    if target.instance_of?(String)
      object_hash = eval(target)
    else
      object_hash = target
    end
    if obj == nil
      obj = object_hash["type"].new
      obj = Marshal.load(obj, object_hash["value"])
    end
    if Marshal::TYPES.include?(object_hash.class)
      obj = object_hash
    elsif object_hash["type"] == Array
      if object_hash["name"] == "instance variables"
        object_hash["value"].each do |item|
          if Marshal::TYPES.include?(item["type"])
            obj.instance_variable_set(item["name"], item["value"])
          else
            newobj = item["type"].new
            obj.instance_variable_set(item["name"], Marshal.load(newobj, item["value"]))
          end
        end
      else
        obj = Array.new
        object_hash["value"].each do |item|
          if Marshal::TYPES.include?(item.class)
            obj << item
          else
            if item["value"].class == Array
              obj << item["value"]
            else
              obj << Marshal.load(obj, item["value"])
            end
          end
        end
      end
    elsif object_hash["type"] == Hash
      if object_hash.has_key?("name")
        newobj = Hash.new
        obj.instance_variable_set(object_hash["name"], Marshal.load(newobj, object_hash["value"]))
      else
        newobj = Hash.new
        object_hash["value"].map do |k, v|
          newobj[k] = v
        end
        obj = newobj
      end
    elsif object_hash.class == Hash
      newobj = object_hash["type"].new
      obj = Marshal.load(newobj, object_hash["value"])
    else
      newobj = object_hash["type"].new
      obj.instance_variable_set(object_hash["name"], Marshal.load(newobj, object_hash["value"]))
    end


    return obj
  end
end
