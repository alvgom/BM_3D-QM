function ColorImaris = RGBAtoImaris(RGBAcolor)
% Adapts color format to Imaris.
%
% DESCRIPTION
%
%   Creates a parameter which can be used as a color in Imaris by using as
%   input a color in the format RGBA
%
% SYNOPSIS
%
%   char_comp = pos2char(pp)
%
% INPUT
%
%   RGBAcolor:                      color in the format [Red Green Blue Alpha],
%                                   where Alpha is the opacity
%
% OUTPUT
%
%   ColorImaris:                    color in a format accepted by Imaris
%

% Author: Alvaro Gomariz Carrillo

rgbaVector = round(RGBAcolor * 255);
rgbaScalar = uint32(rgbaVector * 256 .^ (0 : 3)');
ColorImaris = typecast(rgbaScalar, 'int32');