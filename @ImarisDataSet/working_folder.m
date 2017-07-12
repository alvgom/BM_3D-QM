function [save_dir,FileName_data] = working_folder(this)
% Establishes the folder where the data generated is saved. 
%
% DESCRIPTION
% 
%   The user is asked about the folder to save the data, and a subfolder is
%   created with the name of the image being analyzed
% 
% SYNOPSIS
% 
%   [save_dir,FileName_data] = working_folder(aImarisApplication)
% 
% INPUT
% 
%   aImarisApplicationID: object defining the connection between Imaris and
%                         Matlab. It can be started by using
%                         aImarisApplicationID = GetImaris
%                         If it is part of an ImarisXT, it will be created
%                         automatically as the ImarisXT input

% 
% OUTPUT
% 
%   save_dir:              folder created to save the data of the image in
%                          use
%
%   FileName_data:          name of the image being analyzed
%

% Author: Alvaro Gomariz Carrillo
aImarisApplication = this.aImarisApplication;
full_filename = char(aImarisApplication.GetCurrentFileName());
find_pos = strfind(full_filename,'\');
if isempty(find_pos)
    find_pos = strfind(full_filename,'/');
end
if isempty(find_pos)
    find_pos = 0;
end
FileName_data = full_filename(find_pos(end)+1:end-4);
PathName_data = uigetdir('','Please select the folder where you want to save your data');
if isequal(PathName_data,0)
    save_dir = [];
else
    save_dir = [PathName_data '\' FileName_data '\'];
    if exist(save_dir,'dir') == 0
        mkdir(save_dir);
    end
end
