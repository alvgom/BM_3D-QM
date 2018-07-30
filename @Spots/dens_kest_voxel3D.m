function dens_pdf = dens_kest_voxel3D(this, varargin)
% Kernel Density Estimation of the observed point pattern in 3D.
%
% DESCRIPTION
%
%   This method estimates the probability of finding a point at every voxel
%   given an observed point pattern in 3D

% inputs

X = this.X_voxel0;
mask = uint8(this.mask);
psizes = this.psize;

kernel_ext_factor = 4;
avNN =  mean(this.NNdist);
Sigma = [avNN/this.psize(1),avNN/this.psize(3)];
disp_save_fig = 0;

for i = 1:2:length(varargin)
    switch varargin{i}
        case 'Sigma'
            Sigma = varargin{i+1};
        case 'save_dir'
            save_dir = varargin{i+1};
            disp_save_fig = 1;
        case 'KernelFactor'
            kernel_ext_factor = varargin{i+1};
    end
end

x = X(:,1);
y = X(:,2);
z = X(:,3);
Sigma_xy = Sigma(1);
Sigma_z = Sigma(2);

kernel_ext_xy = kernel_ext_factor*round(Sigma_xy);
kernel_ext_z = kernel_ext_factor*round(Sigma_z);
gkernel = zeros(kernel_ext_xy*2+1,kernel_ext_xy*2+1,kernel_ext_z*2+1, 'uint8');
kcenter_xy = kernel_ext_xy+1;
kcenter_z = kernel_ext_z+1;
N = length(x);
A_gaus = (1/N)*(1/((2*pi)^(3/2)*Sigma_xy^2*Sigma_z));
for i = 1:size(gkernel,1)
    for j = 1:size(gkernel,2)
        for k = 1:size(gkernel,3)
            gkernel(i,j,k) = gkernel(i,j,k) + ...
                A_gaus*exp( -((i-kcenter_xy)^2+ (j-kcenter_xy)^2)/(2*Sigma_xy^2) -(k-kcenter_z)^2/(2*Sigma_z^2));
        end
    end
end
gkernel = gkernel./max(gkernel(:));
% mask_MIP = max(mask,[],3);
dens_est = zeros(size(mask),'uint8');
normal_sumkernel = sum(gkernel(:));

count_error = 0;
h = waitbar(0,'Please wait...');
for pp = 1:N
    prog_bar = double(pp/N);
    waitbar(prog_bar,h,sprintf('Point %d of %d',pp, N));
    if mask(round(x(pp)),round(y(pp)),round(z(pp)))
        lb1 = round(x(pp)-(kcenter_xy-1));
        ub1 = round(x(pp)+(kcenter_xy-1));
        lb2 = round(y(pp)-(kcenter_xy-1));
        ub2 = round(y(pp)+(kcenter_xy-1));
        lb3 = round(z(pp)-(kcenter_z-1));
        ub3 = round(z(pp)+(kcenter_z-1));
        
        klb1 = 1;
        kub1 = size(gkernel,1);
        klb2 = 1;
        kub2 = size(gkernel,2);
        klb3 = 1;
        kub3 = size(gkernel,3);
        if lb1<1
            klb1 = kcenter_xy-round(x(pp))+1;
            lb1=1;
        end
        if ub1>size(mask,1)
            kub1 = size(mask,1)-round(x(pp))+kcenter_xy;
            ub1=size(mask,1);
        end
        if lb2<1
            klb2 = kcenter_xy-round(y(pp))+1;
            lb2=1;
        end
        if ub2>size(mask,2)
            kub2 = size(mask,2)-round(y(pp))+kcenter_xy;
            ub2=size(mask,2);
        end
        if lb3<1
            klb3 = kcenter_z-round(z(pp))+1;
            lb3=1;
        end
        if ub3>size(mask,3)
            kub3 = size(mask,3)-round(z(pp))+kcenter_z;
            ub3=size(mask,3);
        end
        reduced_kernel = gkernel(klb1:kub1,klb2:kub2,klb3:kub3);
        aux_dens = dens_est(lb1:ub1,lb2:ub2,lb3:ub3);
        if isequal(size(aux_dens),size(reduced_kernel))
            kernel_mask = reduced_kernel.*mask(lb1:ub1,lb2:ub2,lb3:ub3);
            corr_factor = sum(kernel_mask(:))/normal_sumkernel;
            dens_est(lb1:ub1,lb2:ub2,lb3:ub3) = aux_dens + kernel_mask/corr_factor;
            %             dens_est(lb1:ub1,lb2:ub2,lb3:ub3) = aux_dens + reduced_kernel/max(reduced_kernel(:));
        else
            count_error = count_error + 1;
        end
    end
end
close(h)
%Apply mask and normalize
% dens_pdf = double(mask).*(dens_est/max(dens_est(:)));
dens_pdf = uint8(mask).*dens_est;
% disp(count_error);

if disp_save_fig
    complete_save_dir = [save_dir 'density_kernel\'];
    if exist(complete_save_dir,'dir') == 0
        mkdir(complete_save_dir);
    end
    
    psizex = psizes(1);
    psizey = psizes(2);
    psizez = psizes(3);
    density_mask = size(X,1)/sum(mask(:))/(psizex*psizey*psizez);
    density_mask_mm = density_mask*1000^3;
    %         mask_MIP = max(mask,[],3);
    %         mask_MIP_rot = imrotate(mask_MIP,90);
    %         % addpath('..\Aux_functions');
    %         % mask_resized = anisotropic_resize(mask_MIP', size(mask,1), size(mask,2), size(mask,3));
    %         mask_resized = imresize(mask_MIP_rot,[size(PPDF1,1), size(PPDF1,2)],'nearest');
    %     dens_pdf_cont = imrotate(mask_MIP.*(dens_pdf+1),90);
    
    fig = figure;
    contourf(1:size(dens_pdf_cont,2),size(dens_pdf_cont,1):-1:1,dens_pdf_cont)
    hold on
    if length(x)<1000
        scatter_psize = 8;
    else
        scatter_psize = 3;
    end
    scatter(x,y,scatter_psize,'w','filled')
    axis image
    %         s = sprintf('Mask density = %f cell/mm^3',density_mask_mm);
    density_total_mm = size(X,1)/size(mask,1)*size(mask,2)*size(mask,3)*1000^3/(psizex*psizey*psizez);
    %         aux_s = sprintf('Total density = %f cell/mm^3',density_total_mm);
    %         legend(aux_s,s);
    saveas(fig,[complete_save_dir 'cell_density_kernel_2D.jpg']);
    save([complete_save_dir 'density_kernel_mat'],'density_mask_mm','density_total_mm');
    close all
end
