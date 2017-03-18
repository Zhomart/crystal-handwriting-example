require "../src/nc"
require "../src/handwriting"

images, labels = Handwriting::MNISTLoader.load("../data/train-images-idx3-ubyte.gz", "../data/train-labels-idx1-ubyte.gz", count: 10)

[0,1,2,3,4].each do |i|
  puts "Image with label #{labels[i]}"
  Handwriting::MNISTLoader.print_image(images[i])
  puts
end
