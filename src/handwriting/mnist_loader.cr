require "gzip"
require "../nc"

module Handwriting
  module MNISTLoader

    def self.load(images_path : String, labels_path : String, count : Int32 | Nil = nil)
      puts "Loading #{count ? count : "all"} MNIST Data from #{images_path}"

      _images = [] of NC::Array(UInt8)
      _labels = [] of UInt8

      File.open(images_path, "rb") do |file|
        Gzip::Reader.open(file) do |gz|
          gz.read_bytes(Int32, IO::ByteFormat::BigEndian)
          _n = gz.read_bytes(Int32, IO::ByteFormat::BigEndian)
          _nrows = gz.read_bytes(Int32, IO::ByteFormat::BigEndian)
          _ncols = gz.read_bytes(Int32, IO::ByteFormat::BigEndian)
          puts "MNIST Image format: n=#{_n}, nrows=#{_nrows}, ncols=#{_ncols}"
          n = count.nil? ? _n : count
          Math.min(n, _n).times do
            slice = Bytes.new(_nrows * _ncols)
            gz.read_fully(slice)
            narray = NC::Array(UInt8).new(slice, {_nrows, _ncols})
            _images << narray
          end
        end
      end

      File.open(labels_path, "rb") do |file|
        Gzip::Reader.open(file) do |gz|
          gz.read_bytes(Int32, IO::ByteFormat::BigEndian)
          _n = gz.read_bytes(Int32, IO::ByteFormat::BigEndian)
          n = count.nil? ? _n : count
          Math.min(n, _n).times do
            _labels << gz.read_byte.as(UInt8)
          end
        end
      end

      {_images, _labels}
    end

    def self.print_image(image : NC::Array(UInt8))
      _nrows = image.shape[0]
      _nrows.times do |i|
        puts _nrows.times.map { |j| image[i, j] > 10 ? "11" : "00" }.join
      end
    end

  end
end
