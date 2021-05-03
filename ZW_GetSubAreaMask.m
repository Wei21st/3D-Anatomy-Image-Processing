%% Get the sub-area mask
% 
% annotation_nii=load_nii('G:\ANTs\transform_test10.nii');
% annotation_matrix=ChangeDirectionToNormal(annotation_nii.img);
% annotation_matrix=uint32(annotation_matrix);
% 
% str_mask0=uint16(annotation_matrix==672);
% Here we know RawBrain_size (by running last script)

% str_mask_resize1=imresize3(STR_matrix,RawBrain_size);
str_mask_resize1=imresize3(uint16(SNr_matrix_gaussblur),RawBrain_size); %CHANGE HERE
Margin=Calculate_SubRegion_Margin(SNr_matrix,320./11773,456./13718);


% previous gained vars: 'str_mask_resize1' (only resize z-axis)
% begining and end number of the 'rawbrain_cut'

cut_startnum=70;
cut_endnum=1613;
mask_size1=size(str_mask_resize1);


%% mask for every z-axis image
% striatum_segmented = zeros(size(1),size(2),size(3),'uint16');
% striatum_only_segmented = zeros(11773,13718,mask_size1(3),'uint16');

k = 0;
time_=char(datetime('now','TimeZone','local','Format','yMMdd-HHmmss'));
savefolder=['H:\' erase(RawBrain_file,'.tif') '_SNr_' time_]; %CHANGE HERE
mkdir(savefolder);

for i=1:mask_size1(3)

    if any(any(str_mask_resize1(:,:,i)))~=0
        k=k+1;
        mask2d=str_mask_resize1(:,:,i);
        mask2d_resize_xy=imresize(mask2d,[11773,13718],'nearest');
        mask2d_resize2=uint16(mask2d_resize_xy);
        
        [folder_num,img_num]=find_img_location(i,cut_startnum);
        im_path= ['H:\20210109_D1_ALM_1_bulk_8um\Stack_' num2str(folder_num) '\StitchedTiff\MergeImages'];
        im_fn=get_sorted_files(im_path);
        img2d=loadTifFast(im_fn{img_num});
        striatum_only=img2d.*mask2d_resize2;
        savename=[savefolder filesep 'SNr_segmented_' num2str(i) '.tif']; %CHANGE HERE
        writeTifFast(savename,striatum_only(Margin(1):Margin(2),Margin(3):Margin(4)),16);
        
%         striatum_only_downsample=imresize(striatum_only,0.64,'nearest');
%         savename_downsample=[savefolder filesep 'SNr_segmented_downsample0.25_' num2str(i) '.tif'];
%         writeTifFast(savename_downsample,striatum_only_downsample,16);
%         func_SaveResult(striatum_test,'striatum_test.tif',[1,1,1]);

        
        
        
    end
    
end
% striatum_only = striatum_segmented(:,:,1:k);
% func_SaveResult(striatum_only,'striatum_seg.tif',[1,1,1]);

function [folder_num,img_num]=find_img_location(z_axis,cut_startnum)
    z_axis=z_axis+cut_startnum-1;
    if z_axis<=125
        folder_num=1;
        img_num=z_axis;
    else
        folder_num=1+ceil((z_axis-125)./112);
        img_num=z_axis-125-112*(folder_num-2);
    end
%     folder_num=num2str(folder_num);
%     img_num=num2str(img_num);
end

function im_fn=get_sorted_files(im_path)
    im_path_dir = dir([im_path filesep '*.tif*']);
    im_fn = natsortfiles(cellfun(@(path,fn) [path filesep fn],...
        {im_path_dir.folder},{im_path_dir.name},'uni',false));
end
