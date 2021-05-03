function func_SaveResult(stack, filename, resolution)
    % func_SaveResult - save output stack in Tiff Stack using ImageJ format
    %
    % Syntax: func_SaveResult(stack, filename, resolution)
    %
    % Save output stack
    % INPUT:
    %   'stack'     - output matrix stack
    %   'filename'  - output filename
    %   'resolution'- stack resolution (3D pixel sizes)
    Progressbar = waitbar(0, ['Saving to: ', filename]);
    RIDescription = {'ImageJ', ...
                    'unit=\u00B5m', ...
                    ['spacing=', num2str(resolution(3), '%.4f')], ...
                    'loop=false', ...
                    'min=0', ...
                    'max=65535'};
    t = Tiff(filename, 'w');

    tagstruct.ImageLength = size(stack, 1);
    tagstruct.ImageWidth = size(stack, 2);
    tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
    tagstruct.BitsPerSample = 16;
    tagstruct.SampleFormat = Tiff.SampleFormat.UInt;
    tagstruct.SamplesPerPixel = 1;
    tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;

    t.setTag('ImageDescription', sprintf('%s\n', RIDescription{:}));
    t.setTag('XResolution', 1 / resolution(1));
    t.setTag('YResolution', 1 / resolution(2));
    t.setTag('ResolutionUnit', 1);

    for k = 1:size(stack, 3)
        t.setTag(tagstruct);
        t.write((stack(:, :, k)));
        t.writeDirectory();
        waitbar(k / size(stack, 3), Progressbar, ['Saving to: ', filename]);
    end

    t.close();
    close(Progressbar);
    disp(['Save stack to ', filename, ' with pixel size (nm): ', num2str(resolution*1000)]);
end
