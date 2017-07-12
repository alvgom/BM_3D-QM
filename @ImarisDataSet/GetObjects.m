function [vObjs,nameObjs] = GetObjects(this,varargin)
%
%   This method returns the specified objects from the Imaris workspace.
%
% SYNOPSIS
%
%   vObjs = GetObjects(aImarisApplication)
%   vObjs = GetObjects(aImarisApplication,varargin)
%
% INPUT
%
%   aImarisApplicationID:   object defining the connection between Imaris and
%                           Matlab. It can be started by using
%                           aImarisApplicationID = GetImaris
%                           If it is part of an ImarisXT, it will be created
%                           automatically as the ImarisXT input
%
%   varargin:               (optional). Write as
%                           ('Specifier1',value1,'Specifier2',value2,...)
%
%           Specifier:      UserMessage: message displayed in the dialog.
%                           Default is 'Select an object:'
%
%                           ObjectType: object types to be displayed
%                           (spot or surface). Default is spot
%
%                           SelectObject: if 1, the user can select the
%                           object, otherwise all the objects specified by
%                           ObjectType are returned. Default is 1
%
% OUTPUT
%
%   vObjs:                  objects specified by the user
%

% Author: Alvaro Gomariz Carrillo
aImarisApplication= this.aImarisApplication;
user_message = 'Select an object:';
objType = 'spot';
selectObj = 1;
for i=1:2:length(varargin)
    switch varargin{i}
        case 'UserMessage'
            user_message = varargin{i+1};
        case 'ObjectType'
            objType = varargin{i+1};
        case 'SelectObject'
            selectObj =  varargin{i+1};
        otherwise
            error(['Unrecognized Command:' varargin{i}]);
    end
end

Objs = {}; nObjs = 0;
nChildren = aImarisApplication.GetSurpassScene().GetNumberOfChildren();
for i = 0 : (nChildren - 1)
    child = aImarisApplication.GetSurpassScene.GetChild( i );
    switch objType
        case 'spot'
            if aImarisApplication.GetFactory().IsSpots(child)
                nObjs = nObjs + 1;
                Objs{nObjs} = ...
                    aImarisApplication.GetFactory().ToSpots(child);
            end
        case 'surface'
            if aImarisApplication.GetFactory().IsSurfaces(child)
                nObjs = nObjs + 1;
                Objs{nObjs} = ...
                    aImarisApplication.GetFactory().ToSurfaces(child);
            end
    end
end
if nObjs == 0
    error('The required object does not exist in Imaris');
elseif selectObj
    for j = 1:nObjs
        Obj_aux = Objs{j};
        ObjNames{j} = char(Obj_aux.GetName());
    end
    [s, v] = listdlg( ...
        'Name', 'Question', ...
        'PromptString', ...
        user_message, ...
        'SelectionMode', 'multiple', ...
        'ListSize', [400 300], ...
        'ListString', ObjNames);
    if v == 0
        vObjs = [];
        nameObjs = [];
        create_sp_mask = 0;
        %         error('You have to select an object in the list');
    else
        for vs = 1:length(s)
            vObjs{vs} = Objs{s(vs)};
            nameObjs{vs} = ObjNames{s(vs)};
        end
    end
else
    vObjs = Objs;
end

