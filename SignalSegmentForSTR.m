function signal=SignalSegmentForSTR(STR_matrix)
    IJ=ij.IJ();
    I=copytoImagePlus(STR_matrix);
    I.show()
    pause(1);
    IJ.runMacroFile('G:\ZhangWei_Registration\StriatumSignalSeg_Final.ijm')
    signal=MIJ.getCurrentImage;
    IJ.run("Clear Results")
    MIJ.closeAllWindows;
end