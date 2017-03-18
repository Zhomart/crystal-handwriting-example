module NC

  # N-dimensional array
  struct Array(T)

    getter :data    # Array(T)
    getter :shape   # Shape
    getter :ndim    # Int32

    def initialize(data : Slice(T) | ::Array(T), shape : Shape | Tuple | Nil = nil)
      @shape = case shape
      when Tuple then Shape.new(shape)
      when Nil then Shape.new({data.size})
      else shape
      end.as(Shape)

      @data = data.to_a.as(::Array(T))
      @ndim = @shape.size.as(Int32)
    end

    def [](*indices)
      raise "Expected #{ndim} dims, got #{indices.size} dims" if indices.size != ndim
      data_ind, n = 0, 1
      indices.zip(shape).reverse_each do |ind, nshape|
        data_ind += n * ind
        n *= nshape
      end
      @data[data_ind]
    end

    def to_s(io : IO)
      io << "array(" << @data << ", type=" << T << ", shape=" << @shape << ")"
    end

    def inspect(io : IO)
      to_s(io)
    end

    def self.zeros(*shape : Int32)
      self.new(::Array(T).new(_shape.total, 0.as(T)), shape: shape)
    end

    struct Shape
      include Indexable(Int32)

      getter :total

      def initialize(ndim_or_shape : Int | Tuple)
        if ndim_or_shape.is_a?(Int)
          @shape = Slice(Int32).new(ndim_or_shape)
        else
          @shape = Slice(Int32).new(ndim_or_shape.size)
          # _shape = Shape.new(shape.size)
          ndim_or_shape.each_with_index { |e, i| @shape[i] = e }
        end
        @total = @shape.reduce(0) { |acc, e| acc + e }.as(Int32)
      end

      def size
        @shape.size
      end

      def unsafe_at(index : Int)
        @shape.unsafe_at(index)
      end

      def []=(index : Int, value : Int32)
        @shape[index] = value
      end

      def to_s(io : IO)
        io << "(" << @shape.join(", ") << ")"
      end

      def inspect(io : IO)
        to_s(io)
      end

    end

  end

end
