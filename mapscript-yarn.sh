#!/usr/bin/env bash

set -e

usage="$0 out_dir in_dir"
if [ "$2" == "" ]
then
	echo $usage
	exit
fi

set -u

out_directory=$1
in_directory=$2

hadoop fs -rmr $out_directory > /dev/null 2>&1 || true

killall spanning_tree || true
./spanning_tree || true

hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
        -Dmapreduce.job.name="vw allreduce $in_directory" \
        -Dmapreduce.map.speculative=true \
        -Dmapreduce.job.reduces=0 \
        -Dmapreduce.job.maps=16 \
        -Dmapreduce.input.fileinputformat.split.minsize=10000000000 \
        -Dmapred.child.java.opts="-Xmx100m" \
        -Dmapred.task.timeout=600000000 \
        -Dmapreduce.map.memory.mb=4000 \
        -input $in_directory \
        -output $out_directory \
        -file vw \
        -file libboost_program_options.so.1.73.0 \
        -file /lib64/libz.so.1 \
        -file runvw-yarn.sh \
        -mapper runvw-yarn.sh \
        -reducer NONE
