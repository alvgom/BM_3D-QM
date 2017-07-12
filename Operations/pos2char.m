function char_comp = pos2char(pp)
% Transforms numbers to characters.
%
% DESCRIPTION
%
%   This method produces transform a number to a character by assigning 'A'
%   to 1, 'B' to 2, ... , 'AA' to 27, 'AB' to 28, and so on
%
% SYNOPSIS
%
%   char_comp = pos2char(pp)
%
% INPUT
%
%   pp:                     number to be transformed into character
%
% OUTPUT
%
%   char_comp:              character produced from the number
%

% Author: Alvaro Gomariz Carrillo

asciiVal1 = floor(pp/26);
asciiVal2 = mod(pp,26);
if asciiVal2 == 0
    asciiVal2 = 26;
    asciiVal1 = asciiVal1-1;
end
if asciiVal1 == 0
    char_comp = char(asciiVal2+'A'-1);
else
    char_comp = [char(asciiVal1+'A'-1) char(asciiVal2+'A')-1];
end
