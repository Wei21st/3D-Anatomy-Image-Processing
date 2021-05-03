% template_folder='H:\20210419_D1_M1tj_Save_confocal_z10um\vignetting test\template_old';
% files=get_sorted_files(template_folder);
% for i = 1:length(files)
%     template(:,:,i)=loadTifFast(files{i});
% end
% template_averaged=mean(template,3);
% max_intensity=max(max(template_averaged));
% template_normalized=template_averaged./max_intensity;
% % template_averaged(template_averaged==0)=0.1;
% figure(1);imagesc(template_normalized);

%% initiate Fiji
RunFiji;
%%
work_folder='F:\20200421_D1_373_M1ul_confocal_z10um\1st\stitch';
stack_files=dir([work_folder filesep 'stack*']);
MIJ.run("Image Sequence...", "open=F:\20200421_D1_373_M1ul_confocal_z10um\1st\stitch\stack_20_51_5.4609 scale=20 sort use");
MIJ.run("Z Project...", "projection=[Average Intensity]");
MIJ.run("Gaussian Blur...", "sigma=20");
I = MIJ.getCurrentImage;
% MIJ.closeAllWindows()
% I=double(I)./max(max(I));
%% Get vignetting mask for each stack level using stack1
work_folder='F:\20200421_D1_373_M1ul_confocal_z10um\1st\stitch';
AVG_mask_folder=[work_folder filesep 'AVG_stack'];
mkdir(AVG_mask_folder);
stack_files=dir([work_folder filesep 'stack*']);
Miji(false);
for i = 1:51
    stack_name=[work_folder filesep stack_files(i).name];
    MIJ.run("Image Sequence...", ['open='  stack_name ' scale=20 sort use']);
    MIJ.run("Z Project...", "projection=[Average Intensity]");
%     MIJ.run("Gaussian Blur...", "sigma=40");
    I = MIJ.getCurrentImage;   
    I=imgaussfilt(double(I),40);
    I_norm=double(I)./double(max(max(I)));
%     savename=[AVG_mask_folder filesep 'mask4stack_' num2str(i,'%02d') '.tif'];
%     imwrite(I_norm,savename,'tif');
    vignetting_mask(:,:,i)=I_norm;
    MIJ.run("Clear Results");
    MIJ.closeAllWindows;
end
savename=[AVG_mask_folder filesep 'vignetting_mask.mat'];
save(savename,'vignetting_mask');

vignetting_avg=mean(vignetting_mask,3);
savename_AVG=[AVG_mask_folder filesep 'vignetting_avg.mat'];
save(savename_AVG,'vignetting_avg');

%%
load(savename_AVG);
test_folder='F:\20200421_D1_373_M1ul_confocal_z10um\vignetting_test\stack_14_30_8.3563';
FOV=get_sorted_files(test_folder);
for i =1 : length(FOV)
    img=loadTifFast(FOV{i});
    img=double(img)./vignetting_avg;
    writeTifFast(FOV{i},img,16);
end






