function CellDensity(aImarisApplication)
% ImarisXT: calculates cell density
%
% DESCRIPTION
%
% ImarisXT: takes a DAPI mask and a spot object as input to calculate the
% density of spots within the mask
%
%    <CustomTools>
%      <Menu>
%        <Submenu name="quantitativeBM">
%          <Item name="Cell Density" icon="Matlab">
%            <Command>MatlabXT::CellDensity(%i)</Command>
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

% DAPI mask
maskDAPI = brid.useMask_usr('DAPI');

% Spots
Cells = brid.constructSpots([],maskDAPI);

% Statistics
volume_dapi_um = sum(maskDAPI(:))*(brid.psize(1)*brid.psize(2)*brid.psize(3));
nCells = Cells.Nspots;
density_cells_dapi_mm = nCells/(volume_dapi_um*((1e-3)^3));

% Write table
cell_mdata_propnames = {'Cell density (cell/mm3)'};
cell_mdata_features = density_cells_dapi_mm;
WriteGroupTable(cell_mdata_features,cell_mdata_propnames,FileName_data,save_dir,'CellDensity');


