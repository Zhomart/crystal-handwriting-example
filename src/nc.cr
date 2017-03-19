require "./nc/*"

# Numerical Crystal - non-PhD attempt to create numerical library
module NC

  def self.exp(a : NC::Array)
    NC::Array(Float64).copy_from(a) { |indices, e| Math.exp(e) }
  end

end

struct Int32
  # Following macro generates operations with NC::Array and Number
  {% for op in [:+, :-, :*, :/] %}
    {% for _type in [Int32, Int64, Float32, Float64] %}
      {% if _type == Float64 %}
        {% ttype = Float64 %}
      {% elsif _type == Float32 %}
        {% ttype = Float32 %}
        {% elsif _type == Int64 %}
          {% ttype = Int64 %}
      {% else %}
        {% ttype = _type %}
      {% end %}
      def {{op.id}}(a : NC::Array({{_type}})) : NC::Array({{ttype}})
        NC::Array({{ttype}}).copy_from(a) { |_, e| self {{op.id}} e }
      end
    {% end %}
  {% end %}
end

struct Int64
  # Following macro generates operations with NC::Array and Number
  {% for op in [:+, :-, :*, :/] %}
    {% for _type in [Int32, Int64, Float32, Float64] %}
      {% if _type == Float64 || _type == Float32 %}
        {% ttype = Float64 %}
      {% else %}
        {% ttype = Int64 %}
      {% end %}
      def {{op.id}}(a : NC::Array({{_type}})) : NC::Array({{ttype}})
        NC::Array({{ttype}}).copy_from(a) { |_, e| self {{op.id}} e }
      end
    {% end %}
  {% end %}
end

struct Float32
  # Following macro generates operations with NC::Array and Number
  {% for op in [:+, :-, :*, :/] %}
    {% for _type in [Int32, Int64, Float32, Float64] %}
      {% if _type == Float64 || _type == Int64 %}
        {% ttype = Float64 %}
      {% else %}
        {% ttype = Float32 %}
      {% end %}
      def {{op.id}}(a : NC::Array({{_type}})) : NC::Array({{ttype}})
        NC::Array({{ttype}}).copy_from(a) { |_, e| self {{op.id}} e }
      end
    {% end %}
  {% end %}
end

struct Float64
  # Following macro generates operations with NC::Array and Number
  {% for op in [:+, :-, :*, :/] %}
    {% for _type in [Int32, Int64, Float32, Float64] %}
      def {{op.id}}(a : NC::Array({{_type}})) : NC::Array(Float64)
        NC::Array(Float64).copy_from(a) { |_, e| self {{op.id}} e }
      end
    {% end %}
  {% end %}
end
