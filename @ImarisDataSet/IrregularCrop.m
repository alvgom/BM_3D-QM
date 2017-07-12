function IrregularCrop(this)

% Initialize
iDataSet = this.aDataSet;
nChannel = askuserChannel(iDataSet,'Select the channel to visualize');
vVol = ImarisGetVolume(nChannel,iDataSet);


% User selection
figure
imshow(max(vVol,[],3),[])
hold on
button = 1;
X = [];
Y = [];
while button == 1
   [x,y,button] = ginput(1);
   X = [X;x];
   Y = [Y;y];
   plot(X,Y,'r')
end
X = [X;X(1)];
Y = [Y;Y(1)];
[XXout] = check_coordinates_limit(size(vVol),[X Y]);
X2 = XXout(:,1);
Y2 = XXout(:,2);
plot(X2,Y2,'y')

% Crop image
mask2D = poly2mask(X, Y, size(vVol,1),size(vVol,2));
mask3D = repmat(mask2D,[1 1 size(vVol,3)]);
vVol(~mask3D) = 0;

% To Imaris
nChannels = iDataSet.GetSizeC();
for cc = 0:nChannels-1
    clear vVol
    vVol = this.GetVolume(cc);
    vVol(~mask3D) = 0;
    brid.SetVolume(vVol,cc);
end
close all
