function HomogeneityTest(aImarisApplication)
% ImarisXT: performs homogeneity test
%
% DESCRIPTION
%
% ImarisXT: performs homogeneity test for a spot object using as a
% covariate the distance to a given surface object
%
%    <CustomTools>
%      <Menu>
%        <Submenu name="BM_3D-QM">
%          <Item name="Homogeneity Test" icon="Matlab">
%            <Command>MatlabXT::HomogeneityTest(%i)</Command>
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

% Spots
Cells = brid.constructSpots([],mask_dapi);

% Distance transform to vessels
[distVesselsAll,scl_resize] = brid.imresize3D_custom(double(mask_vessels),'um','cubic');
[mask_dapi_um,~] = brid.imresize3D_custom(double(mask_dapi),'um','cubic');
dist3d = bwdist_full(distVesselsAll>0.5)/scl_resize;
distVesselsPos=dist3d;
distVesselsPos(dist3d<0 | mask_dapi_um<0.5) = nan;

% Distance to vessels
distVesselsLim = dist3d;
distVesselsLim(dist3d<0) = 0;
distVesselsLim(mask_dapi_um<1) = nan;
dist_cell2vessels = Cells.evalDTspots(distVesselsLim,save_dir);

% Homogeneity test
Cells.CSRtestDT(distVesselsPos,dist_cell2vessels,save_dir);

% Save distances
save(fullfile(save_dir,'dist_cell2vessel'),'dist_cell2vessels','dist3d');



