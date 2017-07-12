function channelNames = getChannelnames(this)


aDataSet = this.aDataSet;
if nargin < 2
    inst_message = [];
end
nChannels = aDataSet.GetSizeC();
channelNames = cell(1,nChannels);
for i = 0:nChannels-1
    channelNames{i+1} = char(aDataSet.GetChannelName(i));
end