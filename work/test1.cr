require "../src/nc"
require "../src/handwriting"

images, labels = Handwriting::MNISTLoader.load("../data/train-images-idx3-ubyte.gz", "../data/train-labels-idx1-ubyte.gz", count: 10)

[0,1,2,3,4].each do |i|
  puts "Image with label #{labels[i]}"
  Handwriting::MNISTLoader.print_image(images[i])
  puts
end

# def sigmoid(z)
# end

a = NC::Array.new([1,2,3,4,5,6,7,8,9,10,11,12], shape: {2,3, 2})
p a
p a.sub(1, 0)
p NC.exp(a)

q = [1, 2, [2,3]]
p typeof(q)
p q.class

c = NC::Array.new([[1,2,3], [4,5,6]])
p c
