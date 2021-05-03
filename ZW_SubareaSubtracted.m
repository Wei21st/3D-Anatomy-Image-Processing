%%Subarea subtracted in dowmsampled images(analyse use)

D1orD2=1;
registration_path='G:\ANTs\D1_ALM_TEST02_resize0.06';
analysis_RawBrain_path='I:\20210129_D1_ALM_02_bulk_8um\CombinedStacks1_16\analysis_downsample_xy0.65_zMIP2';
CutConfig_path='I:\20210129_D1_ALM_02_bulk_8um\CombinedStacks1_16\registration_downsample_xy0.06_zMIP2\CutConfig.mat';

CutConfig=load(CutConfig_path);

% RawBrain_after_regi=load_nii('D1_ALM_TEST02_regiWarped.nii.gz');

% addpath(work_path);
% RawBrain_after_regi=ChangeDirectionToNormal(RawBrain_after_regi.img);
if D1orD2==1
    transform_STR=load_nii([registration_path filesep 'transform_STR.nii']);
    transform_STR=ChangeDirectionToNormal(transform_STR.img);
    test=transform_STR(:,:,100);
    test_gauss=imgaussfilt(uint16(test),1.5);
    
    transform_SNr=load_nii([registration_path filesep 'transform_SNr.nii']);
    transform_SNr=ChangeDirectionToNormal(transform_SNr.img);
    
    transform_GPe=load_nii([registration_path filesep 'transform_GPe.nii']);
    transform_GPe=ChangeDirectionToNormal(transform_GPe.img);
    
    
end



% function subarea=subarea_subtracted(subarea_mask, )    
%     mask=(an25_cut==gray_value);
%     mask=imgaussfilt3(uint16(mask),1.5);
%     [mask_start,mask_end]=calculate_z_margin(mask);
%     subarea=logical(mask).*RawBrain_after_regi;
%     subarea=subarea(:,:,mask_start:mask_end);
%     save_name=[work_path filesep 'RawBrain25um_registerd_' name '.tif'];
%     func_SaveResult(uint16(subarea),save_name,[1,1,1]);
% 
% end