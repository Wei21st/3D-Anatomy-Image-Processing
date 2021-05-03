%---Change Here----
work_folder1='F:\20200421_D1_373_M1ul_confocal_z10um\1st\stitch\stitched_image';
min_stack=1;
%--------------------
work_folder2=[work_folder1 '\combined_resize0.06'];
files1=dir([work_folder1 filesep '*.tif*']);
files2=dir([work_folder2 filesep '*.tif*']);
overlap_folder1=[work_folder1 filesep 'overlap'];
overlap_folder2=[work_folder2 filesep 'overlap'];
mkdir(overlap_folder1);
mkdir(overlap_folder2);

for i =1:length(files1)
    if isOverlap(files1(i).name,min_stack)
        source1=[work_folder1 filesep files1(i).name];
        movefile(source1,overlap_folder1);
    end
end

for i =1:length(files2)
    if isOverlap(files2(i).name,min_stack)
        source2=[work_folder2 filesep files2(i).name];
        movefile(source2,overlap_folder2);
    end
end
% for i =length(files)
%     if isOverlap(files(i).name,2)
%         source1=[work_folder1 filesep files(i).name];
%         source2=[work_folder2 filesep files(i).name];
%         movefile(source1,overlap_folder1);
%         movefile(source2,overlap_folder2);
%     end
% end

function logic=isOverlap(name,min_stack)
        pattern='_(\w\w)_(\w\w)';
        tokens=regexp(name,pattern,'tokens');
        stack=str2num(char(tokens{1}(1)));
        position_in_stack=str2num(char(tokens{1}(2)));
        if stack==min_stack
            logic=0;
        else
            if ismember(position_in_stack,[47:51])
                logic=1;
            else
                logic=0;
            end
        end
end