function [nChannel,cName] = askuserChannel(this,inst_message)
%
% The channels are listed in a dialog and the user should select one of them.
%
% SYNOPSIS
% 
%   nChannel = askuserChannel(iDataSet,inst_message)
% 
% INPUT
% 
%   iDataSet  : Imaris dataset object. It can be obtained with the command
%               aImarisApplication.GetDataSet()
%
%   inst_message: text which is displayed in the dialog
% 
% OUTPUT
% 
%   nChannel    : number of the selected channel
%

% Author: Alvaro Gomariz Carrillo

if nargin<2 || isempty(inst_message)
    inst_message = 'Please select a channel';
end
channelNames = this.getChannelnames;
[s, v] = listdlg( ...
    'Name', 'Question', ...
    'PromptString', ...
    inst_message, ...
    'SelectionMode', 'multiple', ...
    'ListSize', [400 300], ...
    'ListString', channelNames);
cName = cell(1,length(s));
nChannel = [];
if v == 0
    error('You have to choose one of the options available');
else
    for vs = 1:length(s)
        nChannel(vs) = s(vs)-1;
        cName{vs} = channelNames{s(vs)};
    end
    if length(nChannel) == 1
        cName = cName{1};
    end
end