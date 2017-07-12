function newChannel = SetNewChannel(this,varargin)
%
%   A new channel is created in Imaris where a new image can be allocated.
%
% SYNOPSIS
%
%   newChannel = SetNewChannel(aImarisApplication)
%   newChannel = SetNewChannel(aImarisApplication,varargin)
%
% INPUT
%
%   aImarisApplicationID:   object defining the connection between Imaris and
%                           Matlab. It can be started by using
%                           aImarisApplicationID = GetImaris
%                           If it is part of an ImarisXT, it will be created
%                           automatically as the ImarisXT input
%
%   varargin:               (optional). Write as
%                           ('Specifier1',value1,'Specifier2',value2,...)
%
%           Specifier:      ChannelColor: color for the new channel in the 
%                           format [Red Green Blue Alpha], where Alpha is 
%                           the opacity.
%
%                           ChannelName: name for the new channel
%
% OUTPUT
%
%   newChannel:             number associated to the new channel. Note that
%                           channels start counting at 0 in Imaris
%
%

% Author: Alvaro Gomariz Carrillo

newChannel = this.aDataSet.GetSizeC;
this.aDataSet.SetSizeC(newChannel+1);
for i=1:2:length(varargin)
    switch varargin{i}
        case 'ChannelColor'
            RGBAcolor = varargin{i+1};
            ColorImaris = this.RGBAtoImaris(RGBAcolor);
            this.aDataSet.SetChannelColorRGBA(newChannel,ColorImaris);
        case 'ChannelName'
            ChannelName = varargin{i+1};
            this.aDataSet.SetChannelName(newChannel,ChannelName);
        otherwise
            error(['Unrecognized Command:' varargin{i}]);
    end
end
