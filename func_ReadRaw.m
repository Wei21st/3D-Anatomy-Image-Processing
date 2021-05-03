function [raw_Samp, raw_Back, size_Raw, para_NStack, path_Raw] = func_ReadRaw(size_Raw, searchPath)
    % func_ReadRaw - read ODT raw data
    %
    % Syntax: [raw_Samp, raw_Back, size_Raw, para_NStack, path_Raw] = func_ReadRaw(size_Raw, searchPath)
    %
    % Read two raw tiff stacks
    % INPUT:
    %   'size_Raw'      - check if same as actual read size
    %   'searchPath'    - default search location
    % OUTPUT:
    %   'raw_Samp'      - raw images with sample in 3D matrix
    %   'raw_Back'      - raw images without sample in 3D matrix
    %   'size_Raw'      - 2D sizes of read raw images
    %   'para_NStack'   - number of images in each raw input
    %   'path_Raw'      - location of raw data
    cd(searchPath);
    [filename1, pathname1] = uigetfile({'*.tif'}, 'Select Holograms with Sample');

    if filename1 == 0
        error('Image Selection Cancelled');
    else
        disp('Sample:');
        fullname1 = fullfile(pathname1, filename1);
        disp(fullname1);
    end

    cd(pathname1);
    [filename2, pathname2] = uigetfile({'*.tif'}, 'Select Holograms without Sample');

    if filename2 == 0
        error('Image Selection Cancelled');
    else
        disp('Background:');
        fullname2 = fullfile(pathname2, filename2);
        disp(fullname2);
    end

    info1 = imfinfo(fullname1);
    Size1 = [info1(1).Height, info1(1).Width];
    numStack1 = numel(info1);

    info2 = imfinfo(fullname2);
    Size2 = [info1(2).Height, info1(2).Width];
    numStack2 = numel(info2);

    if any(Size1 ~= Size2)
        error('Image size mismatch');
    elseif numStack1 ~= numStack2
        error('Different stack number');
    end

    Size = Size1;
    para_NStack = numStack1;
    path_Raw = pathname1;

    if any(size_Raw ~= Size)
        warning('Selected stack have different size with program settings');
    end

    size_Raw = Size;

    Progressbar = waitbar(0, 'Reading Images');
    raw_Samp = zeros(Size(1), Size(2), para_NStack, 'single');
    raw_Back = zeros(Size(1), Size(2), para_NStack, 'single');

    warning('off', 'all'); % Suppress all the tiff warnings
    stack1 = Tiff(fullname1);
    stack2 = Tiff(fullname2);

    raw_Samp(:, :, 1) = stack1.read();
    raw_Back(:, :, 1) = stack2.read();
    waitbar(1 / para_NStack, Progressbar, [num2str(1), '/', num2str(para_NStack)]);

    for i = 2:para_NStack
        stack1.nextDirectory();
        stack2.nextDirectory();
        raw_Samp(:, :, i) = stack1.read();
        raw_Back(:, :, i) = stack2.read();
        waitbar(i / para_NStack, Progressbar, [num2str(i), '/', num2str(para_NStack)]);
    end

    waitbar(1, Progressbar, [num2str(para_NStack), '/', num2str(para_NStack)]);
    close(stack1);
    close(stack2);
    warning('on', 'all');
    close(Progressbar);
end
