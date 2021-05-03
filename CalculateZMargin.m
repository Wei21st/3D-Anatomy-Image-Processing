function [z_start,z_end]=CalculateZMargin(subregion_matrix,resize_scale_z)
    matrix_size=size(subregion_matrix);
    inArea=0;
    for i=1:matrix_size(3)
        if inArea==0
            if any(any(subregion_matrix(:,:,i)))~=0
                inArea=1;
                z_start=i;
            end
        else
            if any(any(subregion_matrix(:,:,i)))==0
                z_end=i;
                break;
            end
        end
    end
    z_start=round(double(z_start)./resize_scale_z);
    z_end=round(double(z_end)./resize_scale_z);
end