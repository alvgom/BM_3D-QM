# BM_3D-QM
Code used for image processing, data analysis and visualization of 3D bone marrow images.   
Part of the code is written as ImarisXT written in MATLAB, which are plugins for Imaris software that can be run by following these steps in Imaris:  
1. Click on the file tab.
2. Click on preferences.
3. Click on CustomTools.
4. In the XTensions Folder box, click on Add.
5. Choose the directory where you copied the Matlab files.
6. Now you have the plugins in the Image Processing Tab - BM_3D-QM.

## ImarisXT:  
**CellDensity**: calculates cell density  
**DAPImask**: creates a DAPI mask  
**DensityMap**: produces a density map of cells  
**EmptySpaceDistance**: calculates the empty space distance to a defined structure  
**HomogeneityTest**: performs homogeneity test  
**SegmentVessels**: segmentation of vessels  
**VesselsRatio**: calculates the ratio of vessels in the tissue boundaries  

## MATLAB scripts:  
**DistanceEnvelope**:  creates an envelope with the CDF of empty space distances created in the EmptySpaceDistance ImarisXT
**HomogeneityEnvelope**:  creates an envelope with the CDF of empty space distances and distances from cells created in the HomogeneityTest ImarisXT
