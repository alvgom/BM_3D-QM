function SetVolume(this, vVol, aChannel)
aDataSet = this.aDataSet;
aTime=0;

if nargin<3 || isempty(aChannel)
    aChannel = this.askuserChannel;
elseif strcmp(aChannel,'new')
    aChannel = this.SetNewChannel;
end

nSlices = size(vVol,3);
h = waitbar(0,'Please wait...');
for vSlice = 1:nSlices
    if strcmp(aDataSet.GetType,'eTypeUInt8')
        aDataSet.SetDataSliceBytes(uint8(vVol(:,:,vSlice)), vSlice-1, aChannel, aTime);
    elseif strcmp(aDataSet.GetType,'eTypeUInt16')
        aDataSet.SetDataSliceShorts(uint16(vVol(:,:,vSlice)), vSlice-1, aChannel, aTime);
    else
        aDataSet.SetDataSliceFloats(single(vVol(:,:,vSlice)), vSlice-1, aChannel, aTime);
    end
    prog_bar = double(vSlice/nSlices);
    waitbar(prog_bar,h,sprintf('Slice %d of %d',vSlice, nSlices));
end
close(h)