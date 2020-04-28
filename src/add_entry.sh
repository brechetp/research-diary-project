#!/bin/zsh

force=
seminar=
meeting=
dryrun=
verbose=
pres=
while getopts fsmvtd flags
do
    case $flags in
        f) force=1;;
        s) seminar=1;;
        m) meeting=1;;
        v) verbose=1;;
        d) dryrun=1;;
        p) pres=1;;
        ?) printf "Usage: %s: [-f]\n" $0
            exit 2;;
    esac
done

shift $(($OPTIND-1))

year=`date +%Y`
month=`date +%m`
day=`date +%d`

tstampstr="$year-$month-$day" 

[ -n "$title$" ] && title="${(L)@}" # lower case title
title="${title// /_}"

fname=''

[ -n "$seminar" ] && fname='-seminar'
[ -n "$pres" ] && fname='-pres'
[ -n "$title" ] && fname="$fname-$title"

[ -n "$verbose" ] && echo "Today is $year / $month / $day"


[ ! -d "$year" ] && mkdir $year

#if [ -d "$year" ]; then
    #echo "Adding new entry to directory $year."
#fi

cd $year

if [ -n "$seminar" ];
then
    src='../src/seminar.tex'
elif [ -n "$meeting" ] ;
then
    src='../src/meeting.tex'
elif [ -n "$pres" ] ;
then
    src='../src/pres.tex'
else
    src='../src/entry.tex'
fi

dst="$tstampstr$fname.tex"
echo $dst
[ -n "$dryrun" ] && exit 0

if [ -f "$dst" ]; then
    if [ -z "$force" ]; then
        [ -n "$verbose" ] && echo "A file called '$dst' already exists in diretory $year. Aborting copy of new entry."
        exit
    else
        [ -n "$verbose" ] echo "Overriding existing '$dst'"
    fi
fi

# copy the src entry to the file
cp $src $dst 


[ -L 'last.tex' ] && unlink 'last.tex' 

ln -s $dst 'last.tex'

git add $dst
# take care of replacing the different keywords in the template
platform=`uname`
#if [ "$platform" = "Darwin" ]; then
    #sed -i "s/@year/$year/g" $dst
    #sed -i "s/@MONTH/`date +%B`/g" $dst
    #sed -i "s/@dday/$day/g" $dst
    #sed -i "s/@day/`date +%e`/g" $dst
#else
sed -i "s/@year/$year/g" $dst
sed -i "s/@MONTH/`date +%B`/g" $dst
sed -i "s/@dday/$day/g" $dst
sed -i "s/@day/`date +%e`/g" $dst
#fi

[ -n "$verbose" ] && echo "Finished adding $dst to $year."

