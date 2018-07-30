function SetVolume(this, vVol, aChannel, dtype)
aDataSet = this.aDataSet;
aTime=0;

if nargin<4 || isempty(dtype)
    if strcmp(aDataSet.GetType,'eTypeUInt8')
        dtype = 'uint8';
    elseif strcmp(aDataSet.GetType,'eTypeUInt16')
        dtype = 'uint16';
    else
        dtype = 'float';
    end
end
if nargin<3 || isempty(aChannel)
    aChannel = this.askuserChannel;
elseif strcmp(aChannel,'new')
    aChannel = this.SetNewChannel;
end

nSlices = size(vVol,3);
h = waitbar(0,'Please wait...');
for vSlice = 1:nSlices
    if strcmp(dtype,'uint8');
        this.aImarisApplication.GetDataSet.SetDataSliceBytes(uint8(vVol(:,:,vSlice)), vSlice-1, aChannel, aTime);
    elseif strcmp(dtype,'uint16');
        this.aImarisApplication.GetDataSet.SetDataSliceShorts(uint16(vVol(:,:,vSlice)), vSlice-1, aChannel, aTime);
    else
        this.aImarisApplication.GetDataSet.SetDataSliceFloats(single(vVol(:,:,vSlice)), vSlice-1, aChannel, aTime);
    end
    prog_bar = double(vSlice/nSlices);
    waitbar(prog_bar,h,sprintf('Slice %d of %d',vSlice, nSlices));
end
close(h)