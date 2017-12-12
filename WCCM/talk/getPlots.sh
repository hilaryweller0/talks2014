#!/bin/bash -e

SWES=/home/hilary/OpenFOAM/hilary-2.3.0/run/vSlice

pdfFiles=(
    restingScharKlemp/BTF/save/dt100_cubicUpCPCFit_dpdx_CN/18000/theta.eps
    restingScharKlemp/BTF/save/dt100_cubicUpCPCFit_H_CN/18000/theta.eps
    restingScharKlemp/plots/w.eps
    restingScharKlemp/BTF/save/dt100_cubicUpCPCFit_dpdx_CN/energy.eps
    restingScharKlemp/BTF/save/dt100_cubicUpCPCFit_H_CN/energy.eps
    bubbleRising/hill/save/dt5_cubicUpCPCFit_H_CN/animations/meshTheta_0.eps
    bubbleRising/hill/save/dt5_cubicUpCPCFit_H_CN/animations/meshTheta_1.eps
    bubbleRising/hill/save/dt5_cubicUpCPCFit_H_CN/animations/meshTheta_2.eps
    bubbleRising/hill/save/dt5_cubicUpCPCFit_H_CN/animations/meshTheta_3.eps
    bubbleRising/hill/save/dt5_cubicUpCPCFit_H_CN/animations/meshTheta_4.eps
    bubbleRising/hill/save/dt5_cubicUpCPCFit_H_CN/animations/meshTheta_5.eps
    bubbleRising/hill/save/dt5_cubicUpCPCFit_dpdx_CN/animations/meshTheta_0.eps
    bubbleRising/hill/save/dt5_cubicUpCPCFit_dpdx_CN/animations/meshTheta_1.eps
    bubbleRising/hill/save/dt5_cubicUpCPCFit_dpdx_CN/animations/meshTheta_2.eps
    bubbleRising/hill/save/dt5_cubicUpCPCFit_dpdx_CN/animations/meshTheta_3.eps
    bubbleRising/hill/save/dt5_cubicUpCPCFit_dpdx_CN/animations/meshTheta_4.eps
    bubbleRising/hill/save/dt5_cubicUpCPCFit_dpdx_CN/animations/meshTheta_5.eps
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

