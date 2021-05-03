function signal=SignalSegmentForAxon(Axon_matrix,kind)
    Miji(0);
    IJ=ij.IJ();
    I=copytoImagePlus(Axon_matrix);
    I.show()
    pause(1);
    if kind==1 % signal in GPe/GPi
        IJ.runMacroFile('G:\ZhangWei_Registration\Thresholding_RenyiEntropy.ijm');
    else
         IJ.runMacroFile('G:\ZhangWei_Registration\Thresholding_Shanbhag.ijm');
    end
    signal=MIJ.getCurrentImage;
    IJ.runMacroFile('G:\ZhangWei_Registration\FijiClear_Close.ijm');
end