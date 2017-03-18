#!/bin/bash

DIR="$(dirname "${BASH_SOURCE[0]}")"

[ -f $DIR/../data/train-images-idx3-ubyte.gz ] || \
  curl http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz > $DIR/../data/train-images-idx3-ubyte.gz

[ -f $DIR/../data/train-labels-idx1-ubyte.gz ] || \
  curl http://yann.lecun.com/exdb/mnist/train-labels-idx1-ubyte.gz > $DIR/../data/train-labels-idx1-ubyte.gz

[ -f $DIR/../data/t10k-images-idx3-ubyte.gz ] || \
  curl http://yann.lecun.com/exdb/mnist/t10k-images-idx3-ubyte.gz > $DIR/../data/t10k-images-idx3-ubyte.gz

[ -f $DIR/../data/t10k-labels-idx1-ubyte.gz ] || \
  curl http://yann.lecun.com/exdb/mnist/t10k-labels-idx1-ubyte.gz > $DIR/../data/t10k-labels-idx1-ubyte.gz

echo
echo "Images and labels downloaded into $DIR/../data"
