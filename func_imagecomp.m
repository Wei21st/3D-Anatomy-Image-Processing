function imagecomp(fixed,movingRegistered)
    compare_fig = figure('Name', 'Compare Location: click rawbrain first', 'Position', [200  200 750 270]);
    rawbain_ax = subplot('Position',[0,0,0.5,1]);
    imagesc(fixed);
    template_ax=subplot('Position',[0.5,0,0.5,1]);
    imagesc(movingRegistered);
    colormap(rawbain_ax,'gray');
    colormap(template_ax,'gray');
end