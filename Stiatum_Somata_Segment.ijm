input="F:\\20200421_D1_373_M1ul_confocal_z10um\\macro_test_input\\"
output="F:\\20200421_D1_373_M1ul_confocal_z10um\\macro_test_output\\"
Filelist=getFileList(input);
open(input+Filelist[0]);
wait(1000);
run("Trainable Weka Segmentation");
wait(1000);
selectWindow("Trainable Weka Segmentation v3.2.34");
wait(1000);
call("trainableSegmentation.Weka_Segmentation.loadClassifier", "G:\\ZhangWei_Registration\\STR_Somata_classifier.model");
wait(3000);
for (i = 0; i < Filelist.length; i++) {
	filename=Filelist[i];
	call("trainableSegmentation.Weka_Segmentation.applyClassifier", input, filename, "showResults=true", "storeResults=false", "probabilityMaps=false", "");
	wait(2000);
	selectWindow("Classification result");
	wait(1000);
	saveAs("Tiff", output + "segmented_" + filename);
	wait(1000);
	close();
	wait(10000);
}
