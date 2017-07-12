function VesselsRatio(aImarisApplication)
% ImarisXT: calculates the ratio of vessels in the tissue boundaries
%
% DESCRIPTION
%
% ImarisXT: takes the segmented vessels and the DAPI mask as input to
% calculate the proportion of volume occupied by vessels
%
%    <CustomTools>
%      <Menu>
%        <Submenu name="quantitativeBM">
%          <Item name="Ratio of Vessels" icon="Matlab">
%            <Command>MatlabXT::VesselsRatio(%i)</Command>
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
[save_dir,FileName_data] = brid.working_folder;

% DAPI and vessels masks
maskDAPI = brid.useMask_usr('DAPI');
mask_vessels = brid.useMask_usr('Vessels');

% Statistics
volume_dapi_um = sum(maskDAPI(:))*(brid.psize(1)*brid.psize(2)*brid.psize(3));
volume_sinu_um = sum(mask_vessels(:))*(brid.psize(1)*brid.psize(2)*brid.psize(3));
perc_sinu = volume_sinu_um/volume_dapi_um;

% Write table
cell_mdata_propnames = {'Ratio vessels'};
cell_mdata_features = perc_sinu;
WriteGroupTable(cell_mdata_features,cell_mdata_propnames,FileName_data,save_dir,'VesselsRatio');


