function im_fn=get_sorted_files(im_path)
    im_path_dir = dir([im_path filesep '*.tif*']);
    im_fn = natsortfiles(cellfun(@(path,fn) [path filesep fn],...
        {im_path_dir.folder},{im_path_dir.name},'uni',false));
end