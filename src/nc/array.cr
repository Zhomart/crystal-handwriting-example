module NC

  # N-dimensional array
  #
  # ```
  # mx = NC::Array([1,2,3,4,5,6], {2, 3})
  # byte_mx = NC::Array(UInt8).zeros({4, 4})
  # ```
  class Array(T)

    getter data   : Slice(T)
    getter shape  : Shape
    getter ndim   : Int32
    getter size   : Int32

    def initialize(data : Slice(T) | ::Array(T), shape : Shape | Tuple | Nil = nil)
      @shape = case shape
      when Tuple then Shape.new(shape)
      when Nil then Shape.new({data.size})
      else shape end

      @data = data.is_a?(Slice) ? data : Slice.new(data.to_unsafe, data.size, read_only: true)
      @ndim = @shape.size
      @size = @shape.total
    end

    def indices_to_pos(indices : Tuple) : Int32
      raise ArgumentError.new("Expected #{ndim} dims, got #{indices.size} dims") if indices.size != ndim
      pos, n = 0, 1
      indices.zip(shape).reverse_each do |ind, nshape|
        pos += n * ind
        n *= nshape
      end
      pos
    end

    def pos_to_indices(pos : Int32) : Tuple
      {1}
    end

    def [](*indices)
      @data[indices_to_pos(indices)]
    end

    def sub(*indices) : Array(T)
      raise ArgumentError.new("Dimension out of boundary") if indices.size >= ndim
      total = @size
      left, right = 0, 0
      indices.size.times do |i|
        total /= shape[i]
        right = left + (indices[i] + 1) * total
        left += indices[i] * total
      end
      _shape = Shape.new(@ndim - indices.size)
      _shape.size.times { |i| _shape[i] = @shape[indices.size + i] }
      self.class.new(@data[left, right - left], shape: _shape)
    end

    def to_s(io : IO)
      io << "["
      if 1 < ndim
        shape[0].times { |i|
          sub(i).to_s(io)
          io << ", " if i < shape[0] - 1
        }
      else
        io << @data.join(", ")
      end
      io << "]"
    end

    def inspect(io : IO)
      io << "NC::Array("
      to_s(io)
      io <<", dtype=" << T << ", shape=" << @shape << ")"
    end

    # Following macro generates operations with NC::Array and Number
    {% for op in [:+, :-, :*, :/] %}
      {% for _type in [Int32, Int64, Float32, Float64] %}
        def {{op.id}}(n : {{_type}}) : NC::Array({{_type}})
          NC::Array({{_type}}).copy_from(self) { |_, e| e {{op.id}} n }
        end
      {% end %}
    {% end %}

    def self.zeros(*shape : Int32)
      _shape = Shape.new(shape)
      self.new(::Array(T).new(_shape.total, T.new(0)), shape: _shape)
    end

    def self.copy_from(a : NC::Array)
      data = Pointer(T).malloc(a.size) { |i|
        indices = a.pos_to_indices(i)
        yield(indices, a.data[i])
      }
      slice = Slice(T).new(data, a.size, read_only: true)
      NC::Array(T).new(slice, shape: a.shape)
    end

    struct Shape
      include Indexable(Int32)

      def initialize(ndim_or_shape : Int | Tuple)
        if ndim_or_shape.is_a?(Int)
          @shape = Slice(Int32).new(ndim_or_shape)
        else
          @shape = Slice(Int32).new(ndim_or_shape.size)
          ndim_or_shape.each_with_index { |e, i| @shape[i] = e }
        end
      end

      def total : Int32
        @shape.reduce { |acc, e| acc * e }.as(Int32)
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
