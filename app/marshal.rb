module Marshal
  TYPES = [Fixnum, String, TrueClass, FalseClass, Float, Symbol]

  def Marshal.dump(target)
    instance_hash = Hash.new
    instance_hash["type"] = target.class

    if Marshal::TYPES.include?(instance_hash["type"])
      instance_hash["value"] = target
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

      target.instance_variables.each do |v|
        variable = target.instance_variable_get(v)
        instance_variable_hash = Hash.new
        instance_variable_hash["type"] = variable.class
        instance_variable_hash["name"] = v
        instance_variable_hash["value"] = Marshal.dump(variable)
        temp << instance_variable_hash
      end

      instance_hash["value"] = temp
    end

    return instance_hash
  end

  def Marshal.load(obj = nil, target)
    if target.instance_of?(String)
      puts("#1")
      object_hash = eval(target)
    else
      puts("#2")
      object_hash = target
    end
    
    puts("#7 obhash: #{object_hash.class}")
    if object_hash.class != NilClass && object_hash.class != Array && Marshal::TYPES.include?(object_hash["type"])
      puts("#3")

      if object_hash.has_key?("name")
        obj.instance_variable_set(object_hash["name"], object_hash["value"]["value"])
      else
        obj = object_hash["value"]
      end
    elsif object_hash.class == Array
      puts("#4")

      object_hash.each do |item|
        obj = Marshal.load(obj, item)
      end

    elsif object_hash.class == Hash
      puts("#10")
      if object_hash.has_key? "type"
        if object_hash.has_key? "name"
          obj.instance_variable_set(object_hash["name"], Marshal.load(obj, object_hash["value"]))
        else
          obj = object_hash["type"].new
          obj = Marshal.load(obj, object_hash["value"])
        end

      else

        obj = Hash.new
        obj = Marshal.load(obj, object_hash["value"])
      end

    else
      puts("#6")
      if object_hash.class == NilClass
        return obj
      end
      obj = object_hash["type"].new
      obj = Marshal.load(obj, object_hash["value"])
    end

    return obj
  end
end
