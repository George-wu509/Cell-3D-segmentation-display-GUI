# Cell-3D-segmentation-display-GUI
Segshow_3D is the visualization GUI which shows cell segmentation result and raw images together in 3D view


 ![image](https://github.com/George-wu509/Cell-3D-segmentation-display-GUI/blob/master/cover/Segshow3D%20cover1.png)


Introduction
-------------------------
To identify Zebrafish embryo nucleus from images, we apply 3D image segmentation to detect target and locate nuclei xyz coordinates. Segshow_3D is the visualization GUI which shows cell segmentation result and raw images together in 3D view, and is the sub-GUI to our 3D cell segmentation main GUI. 

 ![image](https://github.com/George-wu509/Cell-3D-segmentation-display-GUI/blob/master/cover/Segshow3D%20cover2.png)

How to run Raw_image3D GUI?
-------------------------
1. download this repository to your local computer. It should contains Raw_image3D.m, Raw_image3D.fig. We also provide example dataset data1.mat which you can download here: https://mega.nz/#F!BAMixDQI!CA3ylmkZwboPSSzYXQq04g
2. Run Raw_image3D or double-click Raw_image3D.fig in matlab.   

 ![image](https://github.com/George-wu509/Cell-3D-segmentation-display-GUI/blob/master/cover/Segshow3D%20cover3.png)

How to use this GUI? 
-------------------------
1. After import data file by clicking ''Open datafile'' button, main figure should display 3D segmentation points(x,y,z), and cross-section raw image. 
2. Using the Z-stack slider bar or input value directly to choice the z-stack raw image you want to display 
3. Using the Consecutive z-stack +- slider bar to choice the display range of 3D segmentation points. To compare the single slice segmentation result with one raw image, please input 0.
4. After clicking the 'Default colorbar value' box, color of each marker is the intensity of segmentation point.
5. Using image alpha to setup the image transparent level(from 0 to 1)
6. You can also mark the segmentaiton reuslt by clicking 'Segmentation flag on' box.


About Data file
-------------------------
data.mat contains four variables in cell format:  

NFstk: multi-layer raw image matrix  
xyzintsegdat: 3D segmentation points([x,y,z, I1, I2]) calculated from main GUI.  
chal_info: image channel information.  
imagename: image file name  
 

Authors
-------------------------
- [George Wu] (https://github.com/George-wu509)(http://tzuching1.weebly.com/)


License
-------------------------
All the software in this repository is released under the MIT License. See [LICENSE](https://github.com/kiteco/plugins/blob/master/LICENSE) for details.
