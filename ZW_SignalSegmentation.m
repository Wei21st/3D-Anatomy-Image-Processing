%% Subtract Area and Signal Segmentation
% @zhangwei, 2021

%---Change Here----
D1orD2=2;
Analysis_img_folder='L:\20212423_D2_233_Barrel_confocal_z10um\1st\stitch\stitched_image';

%--------------------
if ~exist('IJM')
    RunFiji;
end

addpath(nii_savefolder);
img_list=get_sorted_files(Analysis_img_folder);
example_img=loadTifFast(img_list{1});
Analysis_img_XYsize=size(example_img);
half_y=round(Analysis_img_XYsize(2)/2);

% Here we had Bcut_array =0, shows no cut for resize0.06 image stacks
x_total_rf=SizeFixed(1)/Analysis_img_XYsize(1); %fr=resize_factor
y_total_rf=SizeFixed(2)/Analysis_img_XYsize(2);
z_total_rf=SizeFixed(3)/RawBrain_size(3);
rf_savepath=[Analysis_img_folder filesep 'total_resize_factor.mat'];
save(rf_savepath, 'x_total_rf','y_total_rf','z_total_rf');
z_total=RawBrain_size(3);

tform_cp_edges=[1 z_center_edge SizeFixed(3)];
tform_groups = discretize(1:SizeFixed(3), tform_cp_edges); 

for i=1:template_num
    tform_cp_invert{i}=invert(tform_cp{i});
end

%%
if D1orD2==1
        
    STR_savefolder=[Analysis_img_folder filesep 'STR'];
    GPi_savefolder=[Analysis_img_folder filesep 'GPi'];
    SNr_savefolder=[Analysis_img_folder filesep 'SNr'];
    mkdir(STR_savefolder);
    mkdir(GPi_savefolder);
    mkdir(SNr_savefolder);
    
    STR_mask=get_subarea_matrix('transform_STR.nii',tform_cp_invert,tform_groups,z_total); 
    GPi_mask=get_subarea_matrix('transform_GPi.nii',tform_cp_invert,tform_groups,z_total); 
    SNr_mask=get_subarea_matrix('transform_SNr.nii',tform_cp_invert,tform_groups,z_total); 
    
    [STR_start,STR_end]=CalculateZMargin(STR_mask,1);
    [GPi_start,GPi_end]=CalculateZMargin(GPi_mask,1);
    [SNr_start,SNr_end]=CalculateZMargin(SNr_mask,1);
    
    STR_total=zeros(SizeFixed(1),SizeFixed(2),z_total);
    GPi_total=zeros(SizeFixed(1),SizeFixed(2),z_total);
    SNr_total=zeros(SizeFixed(1),SizeFixed(2),z_total);
    
    for i=1:z_total
        STR_in=ismember(i,[STR_start:STR_end]);
        GPi_in=ismember(i,[GPi_start:GPi_end]);
        SNr_in=ismember(i,[SNr_start:SNr_end]);
        
        if STR_in || SNr_in || GPi_in
            raw_img=loadTifFast(img_list{i});
            XYsize=size(raw_img);
            if STR_in
                STR_mask_temp=imresize(STR_mask(:,:,i),XYsize);
                STR=uint16(logical(STR_mask_temp)).*raw_img;
                cut1= CalculateXYMargin(STR(:,1:half_y),1,1);
                cut2=CalculateXYMargin(STR(:,half_y:end),1,1);
                if ~ismember(0,cut1)
                    left_STR=STR(cut1(1):cut1(2),cut1(3):cut1(4));
                    left_signal=SignalSegmentForSTR(left_STR);
                    STR(cut1(1):cut1(2),cut1(3):cut1(4))=left_signal;
                end
                if ~ismember(0,cut2)
                    right_STR=STR(cut2(1):cut2(2),(cut2(3)+half_y-1):(cut2(4)+half_y-1));
                    right_signal=SignalSegmentForSTR(right_STR);
                   STR(cut2(1):cut2(2),(cut2(3)+half_y-1):(cut2(4)+half_y-1))=right_signal;
                end
                save_name=[STR_savefolder filesep 'segmented_raw_' num2str(i,'%02d') '.tif'];
                writeTifFast(save_name,STR,8);
                STR=imgaussfilt(double(STR),5);
                STR_total(:,:,i)=imresize(STR,[SizeFixed(1),SizeFixed(2)],'bicubic');
            end
            
            if SNr_in
                SNr_mask_temp=imresize(SNr_mask(:,:,i),XYsize);
                 SNr=uint16(logical(SNr_mask_temp)).*raw_img;
                cut1= CalculateXYMargin(SNr_mask_temp(:,1:half_y),1,1);
                cut2=CalculateXYMargin(SNr_mask_temp(:,half_y:end),1,1);
                if ~ismember(0,cut1)
                    left_signal=SignalSegmentForAxon(SNr(cut1(1):cut1(2),cut1(3):cut1(4)),2);
                    SNr(cut1(1):cut1(2),cut1(3):cut1(4))=left_signal;
                end
                if ~ismember(0,cut2)
                   right_signal=SignalSegmentForAxon(SNr(cut2(1):cut2(2),(cut2(3)+half_y-1):(cut2(4)+half_y-1)),2);
                   SNr(cut2(1):cut2(2),(cut2(3)+half_y-1):(cut2(4)+half_y-1))=right_signal;
                end

                save_name=[SNr_savefolder filesep 'segmented_raw_' num2str(i,'%02d') '.tif'];
                writeTifFast(save_name,SNr,8);
                SNr_total(:,:,i)=imresize(SNr,[SizeFixed(1),SizeFixed(2)],'bicubic');
            end
        
            if GPi_in
                 GPi_mask_temp=imresize(GPi_mask(:,:,i),XYsize);
                 GPi=uint16(logical(GPi_mask_temp)).*raw_img;
                cut1= CalculateXYMargin(GPi_mask_temp(:,1:half_y),1,1);
                cut2=CalculateXYMargin(GPi_mask_temp(:,half_y:end),1,1);
                if ~ismember(0,cut1)
                    left_signal=SignalSegmentForAxon(GPi(cut1(1):cut1(2),cut1(3):cut1(4)),1);
                    GPi(cut1(1):cut1(2),cut1(3):cut1(4))=left_signal;
                end
                if ~ismember(0,cut2)
                   right_signal=SignalSegmentForAxon(GPi(cut2(1):cut2(2),(cut2(3)+half_y-1):(cut2(4)+half_y-1)),1);
                   GPi(cut2(1):cut2(2),(cut2(3)+half_y-1):(cut2(4)+half_y-1))=right_signal;
                end

                save_name=[GPi_savefolder filesep 'segmented_raw_' num2str(i,'%02d') '.tif'];
                writeTifFast(save_name,GPi,8);
                GPi_total(:,:,i)=imresize(GPi,[SizeFixed(1),SizeFixed(2)],'bicubic');
            end
        
        end
    end
    
    
    STR_signal_matrix=imresize3(STR_total,SizeFixed);
    matrix2nii_save(STR_signal_matrix,nii_savefolder,'STR_signal');

    GPi_signal_matrix=imresize3(GPi_total,SizeFixed);
    matrix2nii_save(GPi_signal_matrix,nii_savefolder,'GPi_signal');

    SNr_signal_matrix=imresize3(SNr_total,SizeFixed);
    matrix2nii_save(SNr_signal_matrix,nii_savefolder,'SNr_signal');

   func_SaveResult(STR_total,[STR_savefolder filesep 'STR_total.tif'],[1,1,1]);
   func_SaveResult(SNr_total,[SNr_savefolder filesep 'SNr_total.tif'],[1,1,1]);
   func_SaveResult(GPi_total,[GPi_savefolder filesep 'GPi_total.tif'],[1,1,1]);
end
       
%%               
if D1orD2==2
   GPe_savefolder=[Analysis_img_folder filesep 'GPe'];
   mkdir(GPe_savefolder)
   
   GPe_mask=get_subarea_matrix('transform_GPe.nii',tform_cp_invert,tform_groups,z_total); 
   [GPe_start,GPe_end]=CalculateZMargin(GPe_mask,1);
   GPe_total=zeros(SizeFixed(1),SizeFixed(2),z_total);
   
   STR_savefolder=[Analysis_img_folder filesep 'STR'];
   mkdir(STR_savefolder)
   
   STR_mask=get_subarea_matrix('transform_STR.nii',tform_cp_invert,tform_groups,z_total); 
   [STR_start,STR_end]=CalculateZMargin(STR_mask,1);
   STR_total=zeros(SizeFixed(1),SizeFixed(2),z_total);
   

   for i=304:z_total
   STR_in=ismember(i,[STR_start:STR_end]);
   GPe_in=ismember(i,[GPe_start:GPe_end]);
   
    if STR_in || GPe_in
        raw_img=loadTifFast(img_list{i});
        XYsize=size(raw_img);
        if GPe_in
             GPe_mask_temp=imresize(GPe_mask(:,:,i),XYsize);
             GPe=uint16(logical(GPe_mask_temp)).*raw_img;
            cut1= CalculateXYMargin(GPe_mask_temp(:,1:half_y),1,1);
            cut2=CalculateXYMargin(GPe_mask_temp(:,half_y:end),1,1);
            if ~ismember(0,cut1)
                left_signal=SignalSegmentForAxon(GPe(cut1(1):cut1(2),cut1(3):cut1(4)),1);
                GPe(cut1(1):cut1(2),cut1(3):cut1(4))=left_signal;
            end
            if ~ismember(0,cut2)
               right_signal=SignalSegmentForAxon(GPe(cut2(1):cut2(2),(cut2(3)+half_y-1):(cut2(4)+half_y-1)),1);
               GPe(cut2(1):cut2(2),(cut2(3)+half_y-1):(cut2(4)+half_y-1))=right_signal;
            end
            
            save_name=[GPe_savefolder filesep 'segmented_raw_' num2str(i,'%02d') '.tif'];
            writeTifFast(save_name,GPe,8);
            GPe_total(:,:,i)=imresize(GPe,[SizeFixed(1),SizeFixed(2)],'bicubic');
        end
        
      if STR_in
            STR_mask_temp=imresize(STR_mask(:,:,i),XYsize);
            STR=uint16(logical(STR_mask_temp)).*raw_img;
            cut1= CalculateXYMargin(STR(:,1:half_y),1,1);
            cut2=CalculateXYMargin(STR(:,half_y:end),1,1);
            if ~ismember(0,cut1)
                left_STR=STR(cut1(1):cut1(2),cut1(3):cut1(4));
                left_signal=SignalSegmentForSTR(left_STR);
                STR(cut1(1):cut1(2),cut1(3):cut1(4))=left_signal;
            end
            if ~ismember(0,cut2)
                right_STR=STR(cut2(1):cut2(2),(cut2(3)+half_y-1):(cut2(4)+half_y-1));
                right_signal=SignalSegmentForSTR(right_STR);
               STR(cut2(1):cut2(2),(cut2(3)+half_y-1):(cut2(4)+half_y-1))=right_signal;
            end
            save_name=[STR_savefolder filesep 'segmented_raw_' num2str(i,'%02d') '.tif'];
            writeTifFast(save_name,STR,8);
            STR=imgaussfilt(double(STR),5);
            STR_total(:,:,i)=imresize(STR,[SizeFixed(1),SizeFixed(2)],'bicubic');
        end
    end
   end
   STR_signal_matrix=imresize3(STR_total,SizeFixed);
    matrix2nii_save(STR_signal_matrix,nii_savefolder,'STR_signal');

    GPe_signal_matrix=imresize3(GPe_total,SizeFixed);
    matrix2nii_save(GPe_signal_matrix,nii_savefolder,'GPe_signal');

   func_SaveResult(STR_total,[STR_savefolder filesep 'STR_total.tif'],[1,1,1]);
   func_SaveResult(GPe_total,[GPe_savefolder filesep 'GPe_total.tif'],[1,1,1]);
end
                


function subarea_matrix=get_subarea_matrix(nii_path,tform,tform_groups,z_total)
    regi_Brain_nii=load_nii(nii_path);
    regi_Brain_matrix=ChangeDirectionToNormal(regi_Brain_nii.img);
    subarea_matrix=uint32(regi_Brain_matrix);
    fixed2d=size(subarea_matrix(:,:,1));
    [z_start,z_end]=CalculateZMargin(subarea_matrix,1);
    for i=z_start:z_end
        subarea_matrix(:,:,i)=imwarp(subarea_matrix(:,:,i),tform{tform_groups(i)},'OutputView',...
        imref2d(fixed2d)); 
    end
    subarea_matrix=ceil(imgaussfilt3(double(subarea_matrix),1.5)); %big enough to subtract signal
    subarea_matrix=imresize3(subarea_matrix,[320,456,z_total]);
end
