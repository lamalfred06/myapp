#!/bin/bash

printUsage() {
echo Picasa was set not to render and show RAW files
echo Initial eyeballing from Picasa should remove bad photos jpeg files
echo Use this program $0 deletes raw files that does not have correspnding jpeg
echo directory name1 always required as 1st parameter, to avoid unintended mass delete.
echo Example : \'$0 Alfred_best_Photos_YunNan\'
echo Example : \'$0 2017/2017_08_02_7D2_5D3_XinJiang\'
return
}

progName=`basename $0`
basedir=`pwd`
logfile=$basedir/out.$progName.$$.txt
rm -f $logfile

while getopts ":h" opt; do   # 1st ":" disables verbose error handling, I handle it below in the '\?' section
    case $opt in
        h) printUsage ;;
        \?) echo "Invalid option: -$OPTARG";;
    esac
done
shift $((OPTIND-1))

if [ -z "$1" ]; then
    printUsage
else
    dir=$1
    if [ -d $dir ]; then
        echo `date` " processing directory $dir ================" | tee -a $logfile
    fi
fi

fcount=0
delcount=0
# Need to handle :
# 2017/2017_08_02_7D2_5D3_XinJiang/7D2_Day2_UrumqiSuburb_Lake/*.CR2
# 2017/2017_08_02_PANA_XinJiang/PANA_Day4/*.RW2
# This script will only drill down to 1 subdir level, to avoid deleting unintended raw files
# Therefore, invoke like delRaw.sh 2017/2017_08_02_7D2_5D3_XinJiang
for f in $dir/*.CR2 $dir/*/*.CR2 $dir/*.CR3 $dir/*/*.CR3 $dir/*.RW2 $dir/*/*.RW2 $dir/*.ORF $dir/*/*.ORF $dir/*.dng $dir/*/*.dng ; do
    # make sure the * and */* are actually globbed to an individual filename
    # instead of remaining like a literal string  .../*/*.RW2
    # That is to avoid subsequent logic acting on .../*/*.RW2 massively
    #echo processing raw file $f >> $logfile
    if [ -f $f ]; then
        fcount=$((fcount + 1))
        fname=${f%.*}
        if [ -f $fname.jpg -o -f $fname.jpeg -o -f $fname.JPG -o -f $fname.JPEG ]; then
            echo "jpeg for $f exists" >> $logfile
        else
            echo "jpeg for $f does not exist, deleting raw file $f" >> $logfile
            rm -f $f
            delcount=$((delcount + 1))
        fi
    fi
done
echo `date` "$fcount raw files processed, $delcount raw files deleted" | tee -a $logfile
echo please check logfile $logfile
