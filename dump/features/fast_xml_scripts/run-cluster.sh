#!/bin/bash

DEBUG=1
MODE=$1

if [ "$DEBUG" == 1 ]; then
    set -x
fi

if [ "$MODE" == "" ]; then
    MODE="train"
fi

echo "Mode: $MODE"

# Options
NUM_THREADS=1
NUM_THREADS_TEST=4
START_TREE=0
NUM_TREE=50
BIAS=1.0
LOG_LOSS_COEFF=1.0
MAX_LEAF=50
LBL_PER_LEAF=10

EXEC_PATH="/nfs/cluster_files/dgengenbach/fast_xml/cpp-FastXML_PfastreXML/FastXML"
TRAIN_CMD="./fastXML_train"
TEST_CMD="./fastXML_test"

dataset="openimages"
data_dir="/nfs/cluster_files/dgengenbach/fast_xml"
results_dir="$data_dir/results"
model_dir="$EXEC_PATH/../Sandbox/Results/$dataset/model"

train_features_file="${data_dir}/cpp.fastxml.features.train.txt"
train_labels_file="${data_dir}/cpp.fastxml.classes.train.txt"

test_features_file="${data_dir}/cpp.fastxml.features.test.txt"
test_labels_file="${data_dir}/cpp.fastxml.classes.test.txt"

SCORE_FILE_PREFIX="${dataset}__NUM_THREADS__${NUM_THREADS}__START_TREE__${START_TREE}__NUM_TREE__${NUM_TREE}__BIAS__${BIAS}__LOG_LOSS_COEFF__${LOG_LOSS_COEFF}__MAX_LEAF__${MAX_LEAF}__LBL_PER_LEAF__${LBL_PER_LEAF}"

score_file_test="${results_dir}/${SCORE_FILE_PREFIX}_test_results.txt"
score_file_train="${results_dir}/${SCORE_FILE_PREFIX}_train_results.txt"

cd $EXEC_PATH

# training
if [ "$MODE" == "train" ]; then
    $TRAIN_CMD \
        $train_features_file \
        $train_labels_file \
        $model_dir \
        -T $NUM_THREADS \
        -s $START_TREE \
        -t $NUM_TREE \
        -b $BIAS \
        -c $LOG_LOSS_COEFF \
        -m $MAX_LEAF \
        -l $LBL_PER_LEAF
fi
# testing
if [ "$MODE" == "test" ]; then
    $TEST_CMD \
        $test_features_file \
        $score_file_test \
        $model_dir \
        -T $NUM_THREADS_TEST

    $TEST_CMD \
        $train_features_file \
        $score_file_train \
        $model_dir \
        -T $NUM_THREADS_TEST
fi


# -T    num_thread      (default=1)
#        Number of threads to use
# -s    start_tree      (default=0)
#        Starting tree index
# -t    num_tree        (default=50)
#        Number of trees to be grown
# -b    bias        (default=1.0)
#        Feature bias value, extre feature value to be appended
# -c    log_loss_coeff      (default=1.0)
#        SVM weight co-efficient
# -l    lbl_per_leaf        (default=100)
#        Number of label-probability pairs to retain in a leaf
# -m    max_leaf        (default=10)
#        Maximum allowed instances in a leaf node. Larger nodes are attempted to be split, and on failure converted to leaves