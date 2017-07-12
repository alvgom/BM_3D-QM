function EmptySpaceDistance(aImarisApplication)
% ImarisXT: calculates the empty space distance to a defined structure
%
% DESCRIPTION
%
% ImarisXT: calculates the empty space distance to an input surface object.
% The distance distribution is stored
%
%    <CustomTools>
%      <Menu>
%        <Submenu name="quantitativeBM">
%          <Item name="Empty Space Distance" icon="Matlab">
%            <Command>MatlabXT::EmptySpaceDistance(%i)</Command>
%          </Item>
%        </Submenu>
%      </Menu>
%    </CustomTools>
%

% Author: Alvaro Gomariz


% Initialize
work_dir = fileparts(mfilename('fullpath'));
addpath(genpath(work_dir));
brid = ImarisDataSet('ImarisBridge',aImarisApplication);
save_dir = brid.working_folder;

% DAPI and vessels masks
mask_dapi = brid.useMask_usr('DAPI');
mask_vessels = brid.useMask_usr('Vessels');

% Transfer image to Imaris
move2Imaris = questdlg('Do you want to transfer the empty space distance image to Imaris',...
    'Update parameters',...
    'Yes','No','No');

% Distance transform to vessels
[mask_vessels_um,scl_resize] = brid.imresize3D_custom(double(mask_vessels),'iso_max','cubic');
[mask_dapi_um,~] = brid.imresize3D_custom(double(mask_dapi),'iso_max','cubic');
dist3d = bwdist_full(mask_vessels_um>0.5)/scl_resize;
dist3d(dist3d<0 | mask_dapi_um<0.5) = nan;
save(fullfile(save_dir,'EmptySpaceDistance'),'dist3d');

% Transfer image to Imaris
if isequal(move2Imaris,'Yes')
    dist3d_vox=brid.imresize3D_custom(dist3d,'voxel');
    nChannel_ESD = brid.SetNewChannel('ChannelName','Empty space distance','ChannelColor',[1 1 1 0]);
    brid.SetVolume(dist3d_vox,nChannel_ESD);
end



