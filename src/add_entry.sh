#!/bin/sh

force=
while getopts f flags
do
    case $flags in
        f) force=1;;
        ?) printf "Usage: %s: [-f]\n" $0
            exit 2;;
    esac
done

year=`date +%G`
month=`date +%m`
day=`date +%d`

echo "Today is $year / $month / $day"

if [ ! -d "$year" ]; then
    mkdir $year
    mkdir $year/images
    cd $year
    ln -s ../images/university_logo.eps .
    ln -s ../images/university_logo.png .
    ln -s ../src/research_diary.sty .
    ln -s ../src/clean.sh clean
    ln -s ../src/compile_today.sh compile_today
    ln -s ../src/usrcmd.sty .
    cd ..
fi

if [ -d "$year" ]; then
    echo "Adding new entry to directory $year."
fi

cd $year
filename=$year-$month-$day.tex

if [ -f "$filename" ]; then
    if [ -z "$force" ]; then
        echo "A file called '$filename' already exists in diretory $year. Aborting addition of new entry."
        exit
    else
        echo "Overriding existing '$filename'"
    fi
fi

cp ../src/entry.tex $filename

platform=`uname`
if [ "$platform" = "Darwin" ]; then
    sed -i "" "s/@year/$year/g" $filename
    sed -i "" "s/@MONTH/`date +%B`/g" $filename
    sed -i "" "s/@dday/$day/g" $filename
    sed -i "" "s/@day/`date +%e`/g" $filename
else
    sed -i "s/@year/$year/g" $filename
    sed -i "s/@MONTH/`date +%B`/g" $filename
    sed -i "s/@dday/$day/g" $filename
    sed -i "s/@day/`date +%e`/g" $filename
fi

echo "Finished adding $filename to $year."
