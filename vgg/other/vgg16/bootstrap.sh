#!/usr/bin/env sh

MODEL_FOLDER='model'

mkdir -p $MODEL_FOLDER

PROTO_TXT="VGG_ILSVRC_16_layers_deploy.prototxt"
CAFFE_MODEL="VGG_ILSVRC_16_layers.caffemodel"
PROTO_TXT_NEW="$MODEL_FOLDER/VGG_ILSVRC_16_layers_deploy.new.prototxt"
CAFFEE_MODEL_NEW="$MODEL_FOLDER/VGG_ILSVRC_16_layers.new.caffemodel"
OUT_NPY="$MODEL_FOLDER/tf_net.npy"
OUT_PY="tf_net.py"

if [ ! -f "$MODEL_FOLDER/$PROTO_TXT" ]; then
    wget --directory-prefix=$MODEL_FOLDER https://gist.githubusercontent.com/ksimonyan/211839e770f7b538e2d8/raw/0067c9b32f60362c74f4c445a080beed06b07eb3/VGG_ILSVRC_16_layers_deploy.prototxt
fi

if [ ! -f "$MODEL_FOLDER/$CAFFE_MODEL" ]; then
    wget --directory-prefix=$MODEL_FOLDER http://www.robots.ox.ac.uk/~vgg/software/very_deep/caffe/VGG_ILSVRC_16_layers.caffemodel
fi

rm "$CAFFEE_MODEL_NEW" "$PROTO_TXT_NEW"
upgrade_net_proto_binary $MODEL_FOLDER/VGG_ILSVRC_16_layers.caffemodel $CAFFEE_MODEL_NEW
upgrade_net_proto_text $MODEL_FOLDER/VGG_ILSVRC_16_layers_deploy.prototxt $PROTO_TXT_NEW

rm "$OUT_PY" "$OUT_NPY"
../caffe-tensorflow/convert.py $PROTO_TXT_NEW --caffemodel $CAFFEE_MODEL_NEW --data-output-path=$OUT_NPY
../caffe-tensorflow/convert.py $PROTO_TXT_NEW --code-output-path $OUT_PY
