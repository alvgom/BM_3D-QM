function WriteGroupTable(cell_mdata_features,cell_mdata_propnames,FileName_data,save_dir,end_name)
%
%   Write a spreadsheet with the data specified as input.
%
% SYNOPSIS
%
%   WriteGroupTable(cell_mdata_features,cell_mdata_propnames,FileName_data,save_dir,end_name)
%
% INPUT
%
%   cell_mdata_features:    column vector with the data to be written in
%                           the spreadsheet
%   
%   cell_mdata_propnames:   cell with the names of the data represented in
%                           cell_mdata_features, in the same order
%
%   FileName_data:          name of the dataset from which the data was
%                           calculated
%
%   save_dir:               folder where the spreadsheet is saved
%   
%   end_name:               termination of the spreadsheet name. It is
%                           recommended to use the name of the group of 
%                           data saved, for instance "properties" or "NN"
%

% Author: Alvaro Gomariz Carrillo

if nargin < 5
    end_name = 'properties';
end
end_name = [end_name '.xls'];
% Write table
cell_mdata_names = {};
cell_mdata_properties = {};
% [FileName_ss,PathName_ss,FilterIndex_ss] = uigetfile('*', ['Select a spreadsheet to store your ' end_name ' data / Cancel to create new. '],save_dir);
FilterIndex_ss = 0;
if FilterIndex_ss == 0
    namexls = [save_dir FileName_data '_' end_name];
else %TODO: check if the given filename already exist. Then replace it
    namexls = [PathName_ss FileName_ss];
    [exnumbers, exstrings] = xlsread(namexls,1);
    for cc = 1:size(exnumbers,2)
        cell_mdata_properties{cc} = exnumbers(:,cc);
        cell_mdata_names{cc} = exstrings{1,cc+1};
    end
end

% cell_mdata_propnames = {'volume_total_um3','volume_sinu_um3','volume_nosinu_um3','volume_dapi_um3','density_cell_total_mm3','density_cells_extravascular_mm3','cell_diameter','perc_vol_cell','perc_vol_cell_nosinu','perc_sinu'};
cell_mdata_properties{end+1} = cell_mdata_features;
cell_mdata_names{end+1} = FileName_data;

last_col_char = pos2char(length(cell_mdata_names));
last_col_char_p1 = pos2char(length(cell_mdata_names)+1);

last_row_p1 = num2str(length(cell_mdata_propnames)+1);
    
for i = 1:length(cell_mdata_names)
    char1 = pos2char(i);
    char1_p1 = pos2char(i+1);
    xlswrite(namexls,cell_mdata_properties{i},1,[char1_p1 '2:' char1_p1 last_row_p1]);    
end
xlswrite(namexls,cell_mdata_names,1,['B1:' last_col_char_p1 '1']);
xlswrite(namexls,cell_mdata_propnames',1,['A2:A' last_row_p1]);
% save([save_dir 'mat_data_prop_table'],'cell_mdata_features','cell_mdata_propnames');