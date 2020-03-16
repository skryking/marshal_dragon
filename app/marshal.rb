module Marshal
  TYPES = [Fixnum, String, TrueClass, FalseClass, Float, Symbol]
  ENUMS = [Array, Hash]

  def Marshal.dump(target)
    hash = Hash.new
    hash["type"] = target.class

    if Marshal::TYPES.include?(target.class)
      hash["value"] = target
    else
      array1 = Array.new
      hash["value"] = array1

      target.instance_variables.each do |var|
        instance_hash = Hash.new
        variable = target.instance_variable_get(var)
        instance_hash["type"] = variable.class
        instance_hash["name"] = var.to_s

        if Marshal::TYPES.include?(instance_hash["type"])
          instance_hash["value"] = variable
        elsif instance_hash["type"] == Hash
          temp = Hash.new

          variable.map do |k, v|
            temp[k] = Marshal.dump(v)
          end

          instance_hash["value"] = temp
        elsif instance_hash["type"] == Array
          temp = Array.new

          variable.each do |item|
            temp << Marshal.dump(item)
          end

          instance_hash["value"] = temp
        else
          instance_hash["value"] = Marshal.dump_instance_variables(variable)
        end

        array1 << instance_hash
      end
    end

    return hash
  end

  def Marshal.dump_instance_variables(target)
    array = Array.new

    target.instance_variables.each do |var|
      instance_hash = Hash.new
      variable = target.instance_variable_get(var)
      instance_hash["type"] = variable.class
      instance_hash["name"] = var.to_s

      if Marshal::TYPES.include?(instance_hash["type"])
        instance_hash["value"] = variable
      elsif instance_hash["type"] == Hash
        temp = Hash.new

        variable.map do |k, v|
          temp[k] = Marshal.dump(v)
        end

        instance_hash["value"] = temp
      elsif instance_hash["type"] == Array
        temp = Array.new

        variable.each do |item|
          temp << Marshal.dump(item)
        end

        instance_hash["value"] = temp
      else
        instance_hash["value"] = Marshal.dump_instance_variables(variable)
      end

      array << instance_hash
    end

    return array
  end

  def Marshal.load(filename)
    input = File.read(filename)
    hash = eval(input)
    obj = hash["type"].new

    if Marshal::TYPES.include?(hash["type"])
      return hash["value"]
    else
      values = hash["value"]

      values.each do |value|
        if Marshal::TYPES.include?(value["type"])
          obj.instance_variable_set(value["name"], value["value"])
        else
          newobj = value["type"].new
          obj.instance_variable_set(value["name"], Marshal.load_instance_variables(newobj, value["value"]))
        end
      end
    end

    return obj
  end

  def Marshal.load_instance_variables(obj, array)
    if array.instance_of?(Hash)

      array.map do |k, v|
        if Marshal::TYPES.include?(v["type"])
          if obj.instance_of?(Hash)
            obj[k] = v["value"]
          elsif obj.instance_of?(Array)
            obj << v["value"]
          else
            obj.instance_variable_set(v["name"], v["value"])
          end

        else
          newobj = v["type"].new

          if obj.instance_of?(Hash)
            obj[k] = Marshal.load_instance_variables(newobj, v["value"])
          elsif obj.instance_of?(Array)
            obj << Marshal.load_instance_variables(newobj, v["value"])
          else
            obj.instance_variable_set(v["name"], Marshal.load_instance_variables(newobj, v["value"]))
          end
        end
      end

    else

      array.each do |item|
        if Marshal::TYPES.include?(item["type"])
          if obj.instance_of?(Hash)
            obj[item["name"]] = item["value"]
          elsif obj.instance_of?(Array)
            obj << item["value"]
          else
            obj.instance_variable_set(item["name"], item["value"])
          end

        else
          newobj = item["type"].new

          if obj.instance_of?(Hash)
            obj[item["name"]] = Marshal.load_instance_variables(newobj, item["value"])
          elsif obj.instance_of?(Array)
            obj << Marshal.load_instance_variables(newobj, item["value"])
          else
            obj.instance_variable_set(item["name"], Marshal.load_instance_variables(newobj, item["value"]))
          end
        end
      end
    end

    return obj
  end
end
