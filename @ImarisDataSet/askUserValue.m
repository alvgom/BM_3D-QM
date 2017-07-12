function out_val = askUserValue(inst_message,init_val)
%
%   A dialog is displayed which ask the user a value.
%
% SYNOPSIS
%
%   out_val = askUserValue(inst_message,init_val)
%
% INPUT
%
%   inst_message: (optional) text which is displayed in the dialog. If
%                  empty, the text 'Please introduce a value' appears
%   init_val:     (optional) initial value displayed in the dialog. If
%                  empty, the 0 appears
%
% OUTPUT
%
%   out_val    : value introduced by the user

% Author: Alvaro Gomariz Carrillo

if nargin < 2
    init_val = 0;
end
if nargin < 1
    inst_message = 'Please introduce a value';
end

answer = inputdlg({inst_message}, 'Input', ...
    1, {num2str(init_val)});
if isempty(answer)
    out_val = init_val;
else
    out_val = str2num(answer{1});
end