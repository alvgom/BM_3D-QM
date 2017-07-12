function SegmentVessels(aImarisApplicationID)
% ImarisXT: segment vessels
%
% DESCRIPTION
%
% ImarisXT: makes use of the algorithm for segmentation of hollow tubular
% structure to detect and close stained vessels
%
%    <CustomTools>
%      <Menu>
%        <Submenu name="quantitativeBM">
%          <Item name="Vessels Segmentation" icon="Matlab">
%            <Command>MatlabXT::SegmentVessels(%i)</Command>
%          </Item>
%        </Submenu>
%      </Menu>
%    </CustomTools>
%

% Author: Alvaro Gomariz


% Initialize
work_dir = fileparts(mfilename('fullpath'));
addpath(genpath(work_dir));
aImarisApplication=aImarisApplicationID;
brid = ImarisDataSet('ImarisBridge',aImarisApplication);

% DAPI mask
brid.useMask_usr('Vessels');
