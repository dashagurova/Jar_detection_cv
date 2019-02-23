#!/bin/bash

if [ $# -eq 0 ]
then
	echo "No arguments supplied"
	echo "to run:"
	echo "./run_many <video file> <name for folder> <version> <number of threads> <frames to each folder>"
	exit 1
fi

video=$1
name=$2
ver=$3
thread=$4
split=$5

tmp="$name$ver"
echo "${tmp}"
mkdir ${tmp}
cd ${tmp}

mkdir raw res csvs crop
home="/home/whiterab22bit/"
base="/home/whiterab22bit/${name}${ver}/"
raw_dir="${base}raw/"
res_dir="${base}res/"
crop_dir="${base}crop/"
csv="${base}csvs/"

echo "going to split frames..."
ffmpeg -i "${home}$video" -r 24/1 ${raw_dir}out%05d.jpg


for i in `seq 1 ${thread}`;
do
	mkdir raw/src${i}
done    

for j in `seq 1 ${thread}`;
do
	echo "${split}"
	ls -Q raw/ | head -${split} | xargs -i mv raw/{}  raw/src${j}/
done
i=1

cd /home/whiterab22bit/models/research/object_detection
for i in `seq 1 ${thread}`;
do
python myscript_crop.py --src_dir="${raw_dir}src${i}/" --res_dir="${res_dir}" --crop_dir="${crop_dir}" --boxes="${csv}info${i}.csv" 
done
