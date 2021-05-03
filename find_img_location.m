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