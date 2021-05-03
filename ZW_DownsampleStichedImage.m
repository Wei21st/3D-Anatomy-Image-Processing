%% Downsample stiched image for imaging analysis and registration
% Downsample light-sheet image and confocal image to the same resolution
% Spinning Disk Confocal, objective lens 10*, 1 pixel~ 1.1 um, z-step 10um
%   no expansion
% Light sheet microscopy, objective lens 2.5*,1 pixel~ 1.3 um, z-step 8um,
%   expansion 1.7~2 
% output resolution for imaging analysis: 
%       light-sheet: xy resize factor:0.65; z: 2 images max intensity
%       projection to 1 image
%       confocal: xy resize factor 0.5 (area 0.25); z: no downsample
% output resolution for registration
%       both, xy resize factor 0.06
%       for light-sheet, z also downsample as imaging analysis
% @zhangwei,2021

%---- Change Here-----
imaging_type=1; % 1 for light-sheet; 2 for confocal;
FolderPath='I:\20210129_D1_ALM_02_bulk_8um\CombinedStacks1_16'; 
%------------------------

Files=get_sorted_files(FolderPath); 
FileNum=size(Files,2);

Analysis_SaveFolder=[FolderPath filesep 'analysis_downsample_xy0.65_zMIP2'];
mkdir(Analysis_SaveFolder);

Registration_SaveFolder=[FolderPath filesep 'registration_downsample_xy0.06_zMIP2'];
mkdir(Registration_SaveFolder);

if imaging_type==1
    % Get z axis MIP, then apply downsample 
    MIP_num=floor(FileNum/2);
    for i= 1:MIP_num
        img1_idx=2*i-1;
        img2_idx=2*i;
        
        img1=loadTifFast(char(Files(img1_idx)));
        img2=loadTifFast(char(Files(img2_idx)));
        
        img_matrix(:,:,1)=img1;
        img_matrix(:,:,2)=img2;
        MIP=max(img_matrix,[],3);
        
        analysis_img=imresize(MIP,0.65,'bicubic');
        registration_img=imresize(MIP,0.06,'bicubic');
        
        ai_saveName=[Analysis_SaveFolder filesep 'imgAnalysis_' num2str(i, '%03d')  '.tif'];
        ri_saveName=[Registration_SaveFolder filesep 'imgRegistration_' num2str(i, '%03d')  '.tif'];
        writeTifFast(ai_saveName,analysis_img,16);
        writeTifFast(ri_saveName,registration_img,16);
    end
end



if imaging_type==2
    for i= 1:FileNum
        img=loadTifFast(char(Files(FileNum)));        
        analysis_img=imresize(MIP,0.5,'bicubic');
        registration_img=imresize(MIP,0.09,'bicubic');
        
        ai_saveName=[Analysis_SaveFolder filesep 'imgAnalysis' num2str(i, '%03d')   '.tif'];
        ri_saveName=[Registration_SaveFolder filesep 'imgRegistration' num2str(i, '%03d')  '.tif' ];
        writeTifFast(ai_saveName,analysis_img,16);
        writeTifFast(ri_saveName,registration_img,16);
    end
end




   