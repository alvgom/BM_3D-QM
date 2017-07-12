function [volOut,scale_size] = imresize3D_custom(this,volIn,size_opt,interp_method)

if nargin<4
    interp_method = 'cubic';
end
scale_size = 1;
if ischar(size_opt)
    switch size_opt
        case 'um'
            size_um = [round(...
                this.imsize(1)*this.psize(1)+1),...
                round(this.imsize(2)*this.psize(2)+1),...
                round(this.imsize(3)*this.psize(3)+1)];
        case 'voxel'
            size_um = this.imsize;
        case 'iso_max'
            size_um = [round(...
                this.imsize(1)*this.psize(1)+1),...
                round(this.imsize(2)*this.psize(2)+1),...
                round(this.imsize(3)*this.psize(3)+1)];
            
            scale_size = max(size(volIn)./size_um);
            size_um = size_um*scale_size;
        case 'iso_min'
            size_um = [round(...
                this.imsize(1)*this.psize(1)+1),...
                round(this.imsize(2)*this.psize(2)+1),...
                round(this.imsize(3)*this.psize(3)+1)];
            
            scale_size = min(size(volIn)./size_um);
            size_um = size_um*scale_size;
    end
end
if verLessThan('matlab','9.2')
    volOut = anisotropic_resize(volIn,size_um,interp_method);
else
    volOut = imresize3(volIn, size_um,interp_method);
end