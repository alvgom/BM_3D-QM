classdef ImarisDataSet
    
    properties
        aImarisApplication = [];
        aDataSet = [];
        
        filename = [];
        pathname = [];
        
        imsize = [];
        aExtendMin = [];
        aExtendMax = [];
        psize = [];
        aType = [];
        
        %imsizex = this.imsize(1); imsizey = this.imsize(2); imsizez = this.imsize(3); aExtendMinX = this.aExtendMin(1); aExtendMinY = this.aExtendMin(2); aExtendMinZ = this.aExtendMin(3);
        %psizex = this.psize(1); psizey = this.psize(2); psizez =this.psize(3); aType = this.aType;
        ImarisXT = {
            'Cells Interactions',...
            'Cells Simulation',...
            'Irregular Crop'};
    end
    
    methods
        % Constructor
        function this = ImarisDataSet(varargin)
            for i = 1:2:length(varargin)
                switch varargin{i}
                    case 'ImarisBridge'
                        bridAux = varargin{i+1};
                        if isa(bridAux, 'Imaris.IApplicationPrxHelper')
                            this.aImarisApplication=bridAux;
                        else
                            javaaddpath ImarisLib.jar
                            vImarisLib = ImarisLib;
                            this.aImarisApplication = vImarisLib.GetApplication(0);
                        end
                end
            end
            if isempty(this.aImarisApplication)
                this.aImarisApplication = this.ImarisBridge;
            end
            if isempty(this.aDataSet)
                this.aDataSet =this.aImarisApplication.GetDataSet;
            end
            
            this.imsize = this.getimsize;
            this.aExtendMin = this.getaExtendMin;
            this.aExtendMax = this.getaExtendMax;
            this.psize = this.getpsize;
            
            this.aType = this.adaptImarisDataType;
            [this.filename, this.pathname] = this.GetFileName;
            
            this.aType = this.adaptImarisDataType;
            %             this.region = this.GetRegionName;
            %             this.ExperimentNumber = this.GetExperimentNumber;
            
        end
    end
    
    methods (Access = public) %Functions
        [aData,aChannel] = GetVolume(this,aChannel);
        [nChannel,cName] = askuserChannel(brid,inst_message);
        [vObjs,nameObjs] = GetObjects(this,varargin);
        [X_um0, X_voxel0, X_um_rw, X_voxel_rw, X_um0_all, X_voxel0_all, X_um_rw_all, X_voxel_rw_all] = GetSpotPositions(this,vSpot,mask);
        [X_um0, X_voxel0, X_um_rw, X_voxel_rw, X_um0_all, X_voxel0_all, X_um_rw_all, X_voxel_rw_all] = GetSpotPositions_voxel(this,vSpot,mask);
        newChannel = SetNewChannel(this,varargin);
        [save_dir,FileName_data] = working_folder(this);
        stack = SurfacetoMask(this,surface);
        mask = useMask_usr(this,mask_name);
        DataVol = constructImageVol(this,imVol);
        DataSpots = constructSpots(this,vSpots,mask);
        [spRad,spCenter] = fitSpheresSurf(this);
        [volOut,scale_size] = imresize3D_custom(this,volIn,size_opt,interp_method)
        volDataset = constructVolumeDataset(this,volDataset);
        channelNames = getChannelnames(this);
        Spots = getAllSpots(this);
        distDT = distributionDT(this,mask,varargin);
    end
    
    methods (Access = public) %ImarisXT
        CellsInteractions(this,varargin);
        IrregularCrop(this);
    end
    
    methods (Access = public, Static = true)
        ColorImaris = RGBAtoImaris(RGBAcolor);
        out_val = askUserValue(inst_message,init_val)
        
        function aImarisApplication = ImarisBridge
            fold_init = 'C:\Program Files\Bitplane';
            fold_iVer = dir(fullfile(fold_init, 'Imaris*'));
            if isempty(fold_iVer)
                [FileName_ss,PathName_ss] = uigetfile('*', 'Select the ImarisLib.jar file (usually in the Imaris installation directory)');
                javaFile = [PathName_ss FileName_ss];
            else
                javaFile = fullfile(fold_init,fold_iVer(1).name,'XT\matlab\ImarisLib.jar');
            end
            javaaddpath(javaFile);
            vImarisLib = ImarisLib;
            vObjectId = 0;
            aImarisApplication = vImarisLib.GetApplication(vObjectId);
            if isempty(aImarisApplication)
                warning('It is not possible to set the Imaris-MATLAB bridge. Try restarting the computer');
            end
        end
    end
    
    methods (Access  = private)
        function aType = adaptImarisDataType(this)
            switch char(this.aDataSet.GetType)
                case 'eTypeUInt8'
                    aType = 'uint8';
                case 'eTypeUInt16'
                    aType = 'uint16';
                case 'eTypeFloat'
                    aType = 'float';
                case 'eTypeUnknown'
                    aType = 'unknown';
                otherwise
                    aType = 'unrecognized';
                    warning('Data type was not recognized');
            end
        end
        
        function [filename, pathname] = GetFileName(this)
            filecomplete = char(this.aImarisApplication.GetCurrentFileName);
            [pathname,filename,ext] = fileparts(filecomplete);
        end
        
        function imsize = getimsize(this)
            imsize = [this.aDataSet.GetSizeX(), this.aDataSet.GetSizeY(), this.aDataSet.GetSizeZ()];
        end
        function aExtendMin = getaExtendMin(this)
            aExtendMin = [this.aDataSet.GetExtendMinX(), this.aDataSet.GetExtendMinY(), this.aDataSet.GetExtendMinZ()] ;
        end
        function aExtendMax = getaExtendMax(this)
            aExtendMax = [this.aDataSet.GetExtendMaxX(), this.aDataSet.GetExtendMaxY(), this.aDataSet.GetExtendMaxZ()];
        end
        function psize = getpsize(this)
            psize = [...
                (this.aExtendMax(1)-this.aExtendMin(1))/this.imsize(1),...
                (this.aExtendMax(2)-this.aExtendMin(2))/this.imsize(2),...
                (this.aExtendMax(3)-this.aExtendMin(3))/this.imsize(3)];
        end
        
    end
    
    
    
end
