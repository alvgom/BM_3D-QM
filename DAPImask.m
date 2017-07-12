function DAPImask(aImarisApplication)
% ImarisXT: create a DAPI mask
%
% DESCRIPTION
%
% ImarisXT: morphological image processing is used to create a DAPI mask
% that defines the tissue boundaries
%
%    <CustomTools>
%      <Menu>
%        <Submenu name="BM_3D-QM">
%          <Item name="DAPI mask" icon="Matlab">
%            <Command>MatlabXT::DAPImask(%i)</Command>
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

% DAPI mask
brid.useMask_usr('DAPI');
