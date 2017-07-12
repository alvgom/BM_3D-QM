function stack = SurfacetoMask(this,surface)
% Converts surface object from Imaris into a binary mask. 
%
% DESCRIPTION
% 
%   A surface object from Imaris is converted into a binary mask which is
%   defined with ones inside the surface and 0 outside
% 
% SYNOPSIS
% 
%   stack = SurfacetoMask(iDataSet,surface)
% 
% INPUT
% 
%   iDataSet:             Imaris dataset object. It can be obtained with 
%                         the command aImarisApplication.GetDataSet()
%
%   surface:              surface object from Imaris
% 
% OUTPUT
% 
%   stack:                 binary mask defining the surface object
%

% Author: Alvaro Gomariz Carrillo

stack = zeros(this.imsize);
surfaceMask = surface.GetMask (this.aExtendMin(1), this.aExtendMin(2), this.aExtendMin(3), this.aExtendMax(1), this.aExtendMax(2), this.aExtendMax(3), this.imsize(1), this.imsize(2), this.imsize(3), 0);

switch char(this.aType)
    case 'uint8'
        maskVol = surfaceMask.GetDataVolumeAs1DArrayBytes(0,0);
        stack(:) = typecast(maskVol, 'uint8');
        stack = stack>0;
    case 'uint16'
        maskVol = surfaceMask.GetDataVolumeAs1DArrayShorts(0,0);
        stack(:) = typecast(maskVol, 'uint16');
        stack = stack>0;
    case 'float'
        stack(:) = surfaceMask.GetDataVolumeAs1DArrayFloats(0,0);
    otherwise
        error('Bad value for type');
end
