function DensityMap(aImarisApplication)
% ImarisXT: produces a density map of cells
%
% DESCRIPTION
%
% ImarisXT: takes the DAPI mask and a spot object as input to create a 2D
% density map which is stored in the defined directory
%
%    <CustomTools>
%      <Menu>
%        <Submenu name="BM_3D-QM">
%          <Item name="Density Map" icon="Matlab">
%            <Command>MatlabXT::DensityMap(%i)</Command>
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

% DAPI mask
maskDAPI = brid.useMask_usr('DAPI');

% Spots
Cells = brid.constructSpots([],maskDAPI);

% Density map 3D
move2Imaris = questdlg('Do you want to transfer the 3D density map to Imaris',...
    'Update parameters',...
    'Yes','No','No');
dens_pdf3d = Cells.dens_kest_voxel3D;

% Density map 2D
Cells.dens_kest_2dproj(dens_pdf3d,'save_dir',save_dir);


% Transfer image to Imaris
if isequal(move2Imaris,'Yes')
    DM3d_vox=brid.imresize3D_custom(dens_pdf3d,'voxel');
    nChannel_DM = brid.SetNewChannel('ChannelName','3D density map','ChannelColor',[1 1 1 0]);
    brid.SetVolume(DM3d_vox,nChannel_DM);
end


