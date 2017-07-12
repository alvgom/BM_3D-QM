function [X_um0, X_voxel0, X_um_rw, X_voxel_rw, X_um0_all, X_voxel0_all, X_um_rw_all, X_voxel_rw_all] = GetSpotPositions(this,vSpot,mask)
% Extraction of spots coordinates in different references.
%
% DESCRIPTION
%
% This method converts the coordinates of the points in a spot object to
% different representations that can be used for different purposes
%
% SYNOPSIS
% 
%   [X_um0, X_voxel0, X_um_rw, X_voxel_rw, X_um0_all, X_voxel0_all, X_um_rw_all, X_voxel_rw_all] = GetSpotPositions(aImarisApplication,vSpot)
%   [X_um0, X_voxel0, X_um_rw, X_voxel_rw, X_um0_all, X_voxel0_all, X_um_rw_all, X_voxel_rw_all] = GetSpotPositions(aImarisApplication,vSpot,mask)
% 
% INPUT
% 
%   aImarisApplication:     object defining the connection between Imaris and
%                           Matlab. It can be started by using
%                           aImarisApplicationID = GetImaris
%
%   vSpot:                  spots object from Imaris
%
%   mask:                   (optional) binary image defining the volume
%                           accessible to points in um
% 
% OUTPUT
% 
%   X_um0:                  coordinates of points in accessible voxels 
%                           (defined by the mask) in um and using as origin 
%                           of coordinates the poisition (1,1,1) in the mask
%
%   X_voxel0:               coordinates of points in accessible voxels 
%                           (defined by the mask) in voxel units and using 
%                           as origin of coordinates the poisition (1,1,1) 
%                           in the mask
%
%   X_um_rw:                 coordinates of points in accessible voxels 
%                           (defined by the mask) in um and using as origin 
%                           of coordinates the lower extends of the image
%
%   X_voxel_rw:             coordinates of points in accessible voxels 
%                           (defined by the mask) in voxel units and using 
%                           as origin of coordinates the lower extends of 
%                           the image
%
%   X_um0_all:              coordinates of all points in um and using as origin 
%                           of coordinates the poisition (1,1,1) in the mask
%
%   X_voxel0_all:           coordinates of all points in voxel units and 
%                           using as origin of coordinates the poisition 
%                           (1,1,1) in the mask
%
%   X_um_rw_all:            coordinates of all points in um and using as origin 
%                           of coordinates the lower extends of 
%                           the image
%
%   X_voxel_rw_all:         coordinates of all points in voxel units and 
%                           using as origin of coordinates the lower extends 
%                           of the image
%

% Author: Alvaro Gomariz Carrillo

imsizex = this.imsize(1); imsizey = this.imsize(2); imsizez = this.imsize(3); aExtendMinX = this.aExtendMin(1); aExtendMinY = this.aExtendMin(2); aExtendMinZ = this.aExtendMin(3);
psizex = this.psize(1); psizey = this.psize(2); psizez = this.psize(3);

if nargin < 3
    mask = ones(round(imsizex*psizex+1),round(imsizey*psizey+1),round(imsizez*psizez+1));
end

X_um_rw_all = vSpot.GetPositionsXYZ;
X_um0_all = X_um_rw_all- repmat([aExtendMinX aExtendMinY aExtendMinZ],size(X_um_rw_all,1),1)+1;

X_voxel_rw_all = X_um_rw_all./repmat([psizex psizey psizez],size(X_um_rw_all,1),1);
X_voxel0_all = (X_um_rw_all - repmat([aExtendMinX aExtendMinY aExtendMinZ],size(X_um_rw_all,1),1))./repmat([psizex psizey psizez],size(X_um_rw_all,1),1)+0.5;

exc_pos_aux = round(X_voxel0_all)<ones(size(X_voxel0_all,1),3) | round(X_voxel0_all)>repmat([imsizex imsizey imsizez],size(X_voxel0_all,1),1);
pos_outbound = ~(sum(exc_pos_aux,2)>0);
X_voxel0_all = X_voxel0_all(pos_outbound,:);
X_um_rw_all = X_um_rw_all(pos_outbound,:);
X_voxel_rw_all = X_voxel_rw_all(pos_outbound,:);
X_um0_all = X_um0_all(pos_outbound,:);

count_pp = 0;
pp_posmask = [];
for pp = 1:length(X_um0_all)
    if mask(round(X_um0_all(pp,1)),round(X_um0_all(pp,2)),round(X_um0_all(pp,3)))
        count_pp = count_pp + 1;
        pp_posmask = [pp_posmask pp];
    end
end
X_voxel_rw = X_voxel_rw_all(pp_posmask,:);
X_um_rw = X_um_rw_all(pp_posmask,:);
X_um0 = X_um0_all(pp_posmask,:);
X_voxel0 = X_voxel0_all(pp_posmask,:);