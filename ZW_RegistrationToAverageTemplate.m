%% Registration raw brain data to allen brain averaged template
% owing to the computation capability, we only register to 25um template
% the raw brain data undergo the following step
%       (1) cut the unuseful dark margin in xy
%       (2) pick the start and end slice of the stacked tiff for template
%       and corresponding brain data
%       (3) resize the raw brain as the template in xyz*
%       (4) transfer the matlab matrix to  `.nii` file
%       (5) call windows powershell and run ANTs registration
%       (6) mannual re-adjust the registration to align small nucleu *
%@zhangwei,2021

[RawBrain_file,RawBrain_path] = uigetfile({'*.tif'},'Select an unregistered undownsampled brain image');
RawBrain_fullfile =  fullfile(RawBrain_path,RawBrain_file);
if isequal(RawBrain_file,0)
   disp('User selected Cancel');
else
   disp(['User selected the raw brain image file ', RawBrain_fullfile]);
end
average_template25um_path='G:\HistologyBasedAlign\AllenCCF_atlas\average_template_25_2017.tif';

%% Preprocess before registration
% fixed images
average_template25um=loadTifFast(average_template25um_path);
at25_size=size(average_template25um);
% Choose the beginning and end slice of template
Acut_array=[0,0,0,0,95,465];
at25_cut=average_template25um(:,:,Acut_array(5):Acut_array(6)); 
%-----------------------------------------------
SizeFixed=size(at25_cut);

% moving images
RawBrain=loadTifFast(RawBrain_fullfile);
RawBrain_size=size(RawBrain);
% Cut the dark margin indicate from max intensity projection
% Choose the beginning and end slice of rawbrain
Bcut_array=[45,640,40,824,62,1014];
RawBrain_cut=RawBrain(Bcut_array(1):Bcut_array(2),Bcut_array(3):Bcut_array(4),Bcut_array(5):Bcut_array(6));
cut_config_savepath=[RawBrain_path 'CutConfig.mat'];
save(cut_config_savepath,'Acut_array','Bcut_array','RawBrain_size','at25_size');
%-----------------------------------------------
RawBrain_size=size(RawBrain_cut);
RawBrain_cut_Resize=imresize3(RawBrain_cut,SizeFixed,'cubic');
RawBrain_cut_Resize=imgaussfilt3(RawBrain_cut_Resize,0.5);
RawBrain_cut_Resize(RawBrain_cut_Resize<231)=0;

%% Change Matrix/Tiff to nii
% raw code from Yin Xin 2016, change slightly
ANTs_folder='G:\ANTs';
nii_savefolder=[ANTs_folder filesep erase(RawBrain_file, '.tif')];
time_=char(datetime('now','TimeZone','local','Format','yMMdd-HHmmss'));
mkdir(nii_savefolder);

Brain_savename=[nii_savefolder filesep 'Brain_cut.nii'];
Brain_nii=make_nii(ChangeDirectionToNii(RawBrain_cut_Resize));
save_nii(Brain_nii,Brain_savename);
disp('Brain nii successfully made and saved');

at25_cut_savename=[nii_savefolder filesep 'at25_cut.nii'];
at25_cut_nii=make_nii(ChangeDirectionToNii(at25_cut));
save_nii(at25_cut_nii,at25_cut_savename);
disp('Average template nii successfully made and saved');

%% Do the same to annotation25 to prepare for subarea subtraction
annotation25_path='G:\HistologyBasedAlign\AllenCCF_atlas\Annotation25_2015.tif';
annotation25=loadTifFast(annotation25_path);
an25_cut=annotation25(:,:,Acut_array(5):Acut_array(6));

an25_cut_savename=[nii_savefolder filesep 'annotation25_cut.nii'];
an25_cut_nii=make_nii(ChangeDirectionToNii(an25_cut));
save_nii(an25_cut_nii,an25_cut_savename);
disp('annotation nii successfully made and saved');

STR_anno=uint32((an25_cut==672));
STR_nii=make_nii(ChangeDirectionToNii(STR_anno));
STR_savename=[nii_savefolder filesep  'STR_anno.nii'];
save_nii(STR_nii,STR_savename);


SNr_anno=uint32((an25_cut==381));
SNr_nii=make_nii(ChangeDirectionToNii(SNr_anno));
SNr_savename=[nii_savefolder filesep  'SNr_anno.nii'];
save_nii(SNr_nii,SNr_savename);

GPe_anno=uint32((an25_cut==1022));
GPe_nii=make_nii(ChangeDirectionToNii(GPe_anno));
GPe_savename=[nii_savefolder filesep  'GPe_anno.nii'];
save_nii(GPe_nii,GPe_savename);

GPi_anno=uint32((an25_cut==1031));
GPi_nii=make_nii(ChangeDirectionToNii(GPi_anno));
GPi_savename=[nii_savefolder filesep  'GPi_anno.nii'];
save_nii(GPi_nii,GPi_savename);
%% Call WindowsPowershell to Run ANTs registration

%% Mannual re-adjust the registration to align small nucleu
