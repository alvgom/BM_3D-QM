function maskSpots = MaskSpots(this, imsize)
% Creates mask with segmented spots.
%
% DESCRIPTION
%
%   A binary mask is created by placing spheres with a defined radius at
%   the positions specified in the input
%
% SYNOPSIS
%
%   mask = MaskSpots(aImarisApplication, X, spotRad)
%
% INPUT
%
%   aImarisApplicationID: object defining the connection between Imaris and
%                         Matlab. It can be started by using
%                         aImarisApplicationID = GetImaris
%                         If it is part of an ImarisXT, it will be created
%                         automatically as the ImarisXT input
%
%   X:                    coordinates of the points used to build spheres
%
%   spotRad:              radius of the spheres
%
% OUTPUT
%
%   mask:                  binary mask with spheres located at the
%                          specified coordinates
%

% Author: Alvaro Gomariz Carrillo

X = this.X_voxel0;

spotRad_aux = this.radius_um;
spotRad_vox_aux = spotRad_aux./repmat(this.psize,[size(spotRad_aux,1) 1]);

if length(spotRad_aux)==1
    spotRad_vox = repmat(spotRad_vox_aux,[size(X,1) 1]);
end

maskSpots = zeros(imsize(1),imsize(2),imsize(3));
for index = 1:size(X,1)
    vPos = X(index, :);
    maskSpots = this.DrawSphere(maskSpots, vPos, spotRad_vox(index,:));
end
end

