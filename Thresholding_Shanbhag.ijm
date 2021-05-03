run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
run("Apply LUT");
wait(1000);
setAutoThreshold("Shanbhag dark");
//run("Threshold...");
setOption("BlackBackground", false);
wait(1000);
run("Convert to Mask");