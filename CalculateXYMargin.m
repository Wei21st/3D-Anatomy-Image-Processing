function cut= CalculateXYMargin (Subregion_matrix,resize_scale_x,resize_scale_y)
    MIP=max(Subregion_matrix,[],3); 
    MIP_size=size(MIP);

    cut=zeros(4,1);
%     row_cut_left=matrix_size(1)/2;
%     row_cut_right=matrix_size(1)/2;
%     colunm_cut_left=matrix_size(2)/2;
%     colunm_cut_right=matrix_size(2)/2;
    
    for row=1:MIP_size(1)
        if sum(MIP(row,:)) ~=0
            cut(1)=row;
            break;
%             row_cut_left=row;
                
        end
    end
    
    for row=MIP_size(1):-1:1
        if sum(MIP(row,:)) ~=0 
            cut(2)=row;
            break;
%             row_cut_right=row;
        end
    end
    
    for col=1:MIP_size(2)
        if sum(MIP(:,col)) ~=0 
            cut(3)=col;
            break;
%             col_cut_left=col;
        end
    end
    
    for col=MIP_size(2):-1:1
        if sum(MIP(:,col)) ~=0 
            cut(4)=col;
            break;
%             col_cut_right=col;
        end
    end
    
    resize_x= @(x) [round(double(x)./resize_scale_x)];
    resize_y= @(x) [round(double(x)./resize_scale_y)];
    cut(1)=resize_x(cut(1));
    cut(2)=resize_x(cut(2));
    cut(3)=resize_y(cut(3));
    cut(4)=resize_y(cut(4));
end