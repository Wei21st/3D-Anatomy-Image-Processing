%move file for lightsheet
work_path='K:\20210113_D1_S1_1_bulk_8um';
files=dir([work_path filesep 'Stack*']);
combined_folder=[work_path filesep 'combined stack'];
mkdir(combined_folder);

for i =1 :length(files)
    stitched_path=[work_path filesep files(i).name filesep 'StitchedTiff'];
    file_names=get_sorted_files(stitched_path);
    for j=1:length(file_names)
        if i==1
            destination_name=[combined_folder filesep files(i).name '_' num2str(j,'%03d') '.tif'];
            movefile(char(file_names(j)), destination_name);
        else
            if j<113
                destination_name=[combined_folder filesep files(i).name '_' num2str(j,'%03d') '.tif'];
                movefile(char(file_names(j)), destination_name);
            end
        end
    end
end

%%
% path='K:\20210113_D1_S1_1_bulk_8um\combined stack\..tif';
% files=dir(path);
% for i = 3:length(files)
%     destination_name=[path filesep files(i).name '.tif'];
%     movefile([path filesep files(i).name],destination_name);
% end