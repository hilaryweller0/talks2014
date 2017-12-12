#!/bin/bash -e

SWES=/home/hilary/OpenFOAM/hilary-2.*/run/*

pdfFiles=(
    restingScharKlemp/BTF/save/SIg_H_quadUpCFC/energy.eps
    restingScharKlemp/BTF/save/SIg_gradp_quadUpCFC/energy.eps
)

pngFiles=(
)

for file in ${cpFiles[*]}
do
    fileNew=`echo $file | sed 's/\//_/g'`
    fileNew=graphics/$fileNew
    rsync -ut $SWES/$file $fileNew
done

for file in ${pngFiles[*]}
do
    fileNew=`echo $file | sed 's/\//_/g' | sed 's/\./p/g' | sed 's/peps//g'`
    fileNew=graphics/$fileNew.png
    pngFile=`echo $SWES/$file | sed 's/.eps/.png/g'`
    
    if [ ! -e $pngFile ] || [ `stat -c "%Y" $SWES/$file` -gt `stat -c "%Y" $pngFile` ]
      then
        echo converting $SWES/$file to $pngFile
        eps2png2 $SWES/$file
    fi

    rsync -ut $pngFile $fileNew
done

for file in ${pdfFiles[*]}
do
    fileNew=`echo $file | sed 's/\//_/g' | sed 's/\./p/g' | sed 's/peps//g'`
    fileNew=graphics/$fileNew.pdf
    pdfFile=`echo $SWES/$file | sed 's/.eps/.pdf/g'`
    
    if [ ! -e $pdfFile ] || [ `stat -c "%Y" $SWES/$file` -gt `stat -c "%Y" $pdfFile` ]
      then
        echo converting $SWES/$file to $pdfFile
        makebb $SWES/$file
        epstopdf $SWES/$file
    fi

    rsync -ut $pdfFile $fileNew
done

