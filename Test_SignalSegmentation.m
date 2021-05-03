%% Signal Segmentation
% Striatum cellbody signal using WEKA Trainable segmentation in Fiji
% Axon signal in GPe, GPi, SNr, using local and global thresholding


%% initialize Fiji
RunFiji;
IJ=ij.IJ();
IJ.run('Open...','path=[C:/Users/zhang/Desktop/temp_save.tif]');
IJ.runMacroFile('E:\fiji-win64\Fiji.app\macros\test0501.ijm')
IJ.save("C:/Users/zhang/Desktop/temp_save4.tif");
MIJ.closeAllWindows;
% MIJ.run("Apply LUT");
% MIJ.run('Threshold...','method=RenyiEntropy white')
MIJ.run("Auto Threshold","method=RenyiEntropy white");
run("Convert to Mask");
run("16-bit");
run("Convert to Mask");
run("16-bit");
IJ.run("Call","Weka_Segmentation.applyClassifier", "I:\\20210423_D1_346_Barrel_confocal_z10um\\1st\\stitch\\stitched_image", "stack_08_31_11.4228_0.5.tif", "showResults=true", "storeResults=false") 
IJ.runPlugIn("Call","loadClassifier","G:\\ZhangWei_Registration\\STR_Somata_classifier.model");
