class Stuff
  attr_accessor :number1, :string1, :truthy, :falsy, :floaty, :array1, :array2, :hash1
    def initialize
      self.number1 = 1
      self.string1 = "Test1"
      self.truthy = true
      self.falsy = false
      self.floaty = 3.14
      self.array1 = Array.new
      self.array1 << 1
      self.array1 << 2
      self.array2 = Array.new
      self.array2 << Array.new
      self.array2[0] << 3
      self.array2[0] << 4
      self.hash1 = Hash.new
      self.hash1["test1"] = 1
      self.hash1["test2"] = 2
    end

    def to_s
        self.serialize.to_s
      end
      
      def inspect
        self.serialize.to_s
     end
    
      def serialize
        hash = {}
        instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
        hash
      end
end

