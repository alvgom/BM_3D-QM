function distDT = distributionDT(this,mask,varargin)

doLim = 0;
imunits = 'um';
for i = 1:2:length(varargin)
    switch varargin{i}
        case 'LimMask'
            maskLim = varargin{i+1};
            doLim = 1;
        case 'units'
            imunits = varargin{i+1};
    end
end

if isequal(imunits,'voxels') || isequal(imunits,'vox') || isequal(imunits,'voxel')
    [mask_um,scl_mask] = this.imresize3D_custom(double(mask),'iso_max','cubic');
else
    mask_um = mask;
    scl_mask = 1;
end
distMask = bwdist_full(mask_um>0.5)/scl_mask;
distMask(distMask<0) = nan;
if doLim
    distMask(maskLim<1) = nan;
end
distDT = distMask(:);

