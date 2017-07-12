function [aData,aChannel] = GetVolume(this, aChannel)
aDataSet = this.aDataSet;
if nargin<2
    aChannel = this.askuserChannel;
end
vSizeX = aDataSet.GetSizeX;
vSizeY = aDataSet.GetSizeY;
vSizeZ = aDataSet.GetSizeZ;
vLayersSize = [vSizeX * vSizeY, vSizeZ];
vSize = [vSizeX, vSizeY, vSizeZ];
h = waitbar(0,'Please wait...');
if strcmp(aDataSet.GetType, 'eTypeUInt8')
  aData = zeros(vLayersSize, 'uint8');
  for vIndexZ = 1:vSizeZ
    aData(:, vIndexZ) = typecast(aDataSet.GetDataSubVolumeAs1DArrayBytes(...
      0, 0, vIndexZ - 1, aChannel, 0, vSizeX, vSizeY, 1), 'uint8');
  prog_bar = double(vIndexZ/vSizeZ);
      waitbar(prog_bar,h,sprintf('Slice %d of %d',vIndexZ, vSizeZ));
  end
elseif strcmp(aDataSet.GetType, 'eTypeUInt16')
  aData = zeros(vLayersSize, 'uint16');
  for vIndexZ = 1:vSizeZ
      aData(:, vIndexZ) = typecast(aDataSet.GetDataSubVolumeAs1DArrayShorts(...
          0, 0, vIndexZ - 1, aChannel, 0, vSizeX, vSizeY, 1), 'uint16');
      prog_bar = double(vIndexZ/vSizeZ);
      waitbar(prog_bar,h,sprintf('Slice %d of %d',vIndexZ, vSizeZ));
  end
elseif strcmp(aDataSet.GetType, 'eTypeFloat')
  aData = zeros(vLayersSize, 'single');
  for vIndexZ = 1:vSizeZ
    aData(:, vIndexZ) = typecast(aDataSet.GetDataSubVolumeAs1DArrayFloats(...
      0, 0, vIndexZ - 1, aChannel, 0, vSizeX, vSizeY, 1), 'single');
  prog_bar = double(vIndexZ/vSizeZ);
      waitbar(prog_bar,h,sprintf('Slice %d of %d',vIndexZ, vSizeZ));
  end
end
close(h);
aData = reshape(aData, vSize);