%% roughly analyse data and show figure
% (1) read aligned RawBrain(already aligned) nii and transfer to normal
%       direction
% (2) read 25um annotation template (z axis cut as RawBrain) and determine
%       subarea location, get the mask
% (3) 

work_path= 'G:\ANTs\D1_ALM_TEST02_resize0.06';
% RawBrain_after_regi=load_nii('D1_ALM_TEST02_regiWarped.nii.gz');

% addpath(work_path);
% RawBrain_after_regi=ChangeDirectionToNormal(RawBrain_after_regi.img);
% Receptor_type=1; %1 for D1; 2 for D2

% annotation25_path='G:\HistologyBasedAlign\AllenCCF_atlas\Annotation25_2015.tif';
% annotation25=loadTifFast(annotation25_path);
an25_cut=annotation25(:,:,Acut_array(5):Acut_array(6));
if Receptor_type==1
    STR=subarea_subtracted(an25_cut,RawBrain_after_regi ,work_path,'Striatum',672);
    SNr=subarea_subtracted(an25_cut,RawBrain_after_regi ,work_path,'SNr',381);
    GPi=subarea_subtracted(an25_cut,RawBrain_after_regi ,work_path,'GPi',1031);
end

if Receptor_type==2
     STR=subarea_subtracted(an25_cut,RawBrain_after_regi ,work_path,'Striatum',672);
     GPe=subarea_subtracted(an25_cut,RawBrain_after_regi ,work_path,'GPi',1022);
end

%% Plot figure
 MIP1=sum(STR,3);
 MIP2=sum(MIP1,2);
 x=1:320;
 MIP2=(MIP2-mean(MIP2))/std(MIP2);
 plot(x,MIP2);
 
 MIP1=sum(STR,3);
 MIP2=sum(MIP1,1);
 x=1:456;
 MIP2=(MIP2-mean(MIP2))/std(MIP2);
 plot(x,MIP2);

%-----------

function subarea=subarea_subtracted(an25_cut,RawBrain_after_regi,work_path, name, gray_value)    
    mask=(an25_cut==gray_value);
    mask=imgaussfilt3(uint16(mask),1.5);
    [mask_start,mask_end]=calculate_z_margin(mask);
    subarea=logical(mask).*RawBrain_after_regi;
    subarea=subarea(:,:,mask_start:mask_end);
    save_name=[work_path filesep 'RawBrain25um_registerd_' name '.tif'];
    func_SaveResult(uint16(subarea),save_name,[1,1,1]);

end

function [z_start,z_end]=calculate_z_margin(subregion_mask)
    mask_size=size(subregion_mask);
    in_mask=0;
    for i = 1:mask_size(3)
        if in_mask==0 && any(any(subregion_mask(:,:,i)))==1
            z_start=i;
            in_mask=1;
        end
        if in_mask==1 && any(any(subregion_mask(:,:,i)))==0
            z_end=i;
            break
        end
    end
end


