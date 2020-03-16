class Stuff
    attr_accessor :otherstuff, :hash1, :array1
    def initialize
      self.array1 = Array.new
      self.array1 << Array.new
      self.array1[0][0] = "teststring"
      
      

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

class OtherStuff
    attr_accessor :array2, :array3
    def initialize
      @va3 = "some stuff"
      @var4 = 3
      self.array2 = Array.new
      self.array3 = Array.new
      self.array2 << 1
      self.array2 << 2
      self.array3 << "test String"
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