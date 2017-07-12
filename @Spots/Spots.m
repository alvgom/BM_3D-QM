classdef Spots < matlab.mixin.Copyable
    properties
        X_um0 = [];
        X_voxel0 = [];
        X_um_rw  = [];
        X_voxel_rw = [];
        
        radius_um = [];
        
        aExtendMin = [];
        aExtendMax = [];
        psize = [];
        
        mask = [];
        Nspots = [];
        NNdist = [];
        
    end
    
    methods
        % Constructor
        
        function this = Spots(X_um_rw,varargin)
            
            if nargin>0
                this.X_um_rw = X_um_rw;
                for i = 1:2:length(varargin)
                    switch varargin{i}
                        case 'aExtendMin'
                            this.aExtendMin = varargin{i+1};
                        case 'aExtendMax'
                            this.aExtendMax = varargin{i+1};
                        case 'psize'
                            this.psize = varargin{i+1};
                        case 'mask'
                            this.mask =  varargin{i+1};
                        case 'radius_um'
                            this.radius_um = varargin{i+1};
                        case 'radius_voxel'
                            this.radius_voxel = varargin{i+1};
                    end
                end
                
                doExtendsLim = ~isempty(this.aExtendMin) & ~isempty(this.aExtendMax);
                if doExtendsLim
                    this.imExtendsLim;
                end
                
                doSizeProp = ~isempty(this.aExtendMin) & ~isempty(this.aExtendMax);
                if doSizeProp
                    this.coordinates_conv;
                end
                
                doLimMask = doSizeProp & ~isempty(this.mask);
                if doLimMask
                    this.spotsLimMask;
                end
                
                this.Nspots = size(this.X_um0,1);
                calcNNdist(this);
            end
            
        end
    end
    
    methods (Access = public)
        maskSpots = MaskSpots(this, imsize);
        dispNN(this,save_dir);
        dens_pdf = dens_kest_voxel3D(this, Sigma, save_dir, kernel_ext_factor)
        point_prob = dens_kest_2dproj(this, dens_pdf3d,varargin);
        [File_EndNames_others, File_vars_others] = points_interaction_nocorr(this,dist_W,lambda_um3,varargin);
        maskContour_um(this,varargin);
    end
    
    methods (Access = public, Static = true)
        pval = CSRtestDT(volDT,feature_vector,save_dir);
        pval = CSRtest_structures(distVol0,maskVolEval,save_dir)
        imData = DrawSphere(imData, aPos, aRad);
    end
    
    methods %(Access = private)
        function coordinates_conv(this)
            this.X_um0 = this.X_um_rw- repmat(this.aExtendMin,size(this.X_um_rw,1),1)+1;
            this.X_voxel_rw = this.X_um_rw./repmat(this.psize,size(this.X_um_rw,1),1);
            this.X_voxel0 = (this.X_um_rw - repmat(this.aExtendMin,size(this.X_um_rw,1),1))./repmat(this.psize,size(this.X_um_rw,1),1)+0.5;
        end
        
        function imExtendsLim(this)
            exc_pos_aux = round(this.X_um_rw)<repmat(this.aExtendMin,size(this.X_um_rw,1),1) | round(this.X_um_rw)>repmat(this.aExtendMax,size(this.X_um_rw,1),1);
            pos_outbound = ~(sum(exc_pos_aux,2)>0);
            this.X_um_rw = this.X_um_rw(pos_outbound,:);
        end
        
        %function [X_um_rw, X_um0,X_voxel_rw,X_voxel0] = spotsLimMask(this)
        function spotsLimMask(this)
            count_pp = 0;
            pp_posmask = [];
            for pp = 1:length(this.X_voxel0)
                if this.mask(round(this.X_voxel0(pp,1)),round(this.X_voxel0(pp,2)),round(this.X_voxel0(pp,3)))
                    count_pp = count_pp + 1;
                    pp_posmask = [pp_posmask pp];
                end
            end
            this.X_voxel_rw = this.X_voxel_rw(pp_posmask,:);
            this.X_um_rw = this.X_um_rw(pp_posmask,:);
            this.X_um0 = this.X_um0(pp_posmask,:);
            this.X_voxel0 = this.X_voxel0(pp_posmask,:);
            this.Nspots = size(this.X_um_rw,1);
        end
        
        function calcNNdist(this)
            X = this.X_um_rw;
            for i = 1:size(X,1)
                x = X;
                x(i,:) = nan(1,size(X,2));
                y = X(i,:);
                [idx(i),dNN(i)] = knnsearch(x,y);
            end
            this.NNdist = dNN;
        end
        
        
    end
end