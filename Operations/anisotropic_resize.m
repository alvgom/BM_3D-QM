function imageOut = anisotropic_resize(imageIn, size_out,interp_method)
% 
%   This method resizes the image as specified in the input.
% 
% SYNOPSIS
% 
%   imageOut = anisotropic_resize(imageIn, nx, ny, nz)
% 
% INPUT
% 
%   imageIn  : input image
%   nx: number of voxels in the first dimension
%   ny: number of voxels in the second dimension
%   nz: number of voxels in the third dimension
% 
% OUTPUT
% 
%   imageOut    : resized image

% Author: Alvaro Gomariz Carrillo

nx = size_out(1);
ny = size_out(2);
nz = size_out(3);

[x, y, z]=...
   ndgrid(linspace(1,size(imageIn,1),nx),...
          linspace(1,size(imageIn,2),ny),...
          linspace(1,size(imageIn,3),nz));
imageOut=interp3(imageIn,y,x,z,interp_method);
