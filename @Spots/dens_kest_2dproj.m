function point_prob = dens_kest_2dproj(this, dens_pdf3d,varargin)


do_save = 0;
maxscl_comp = 1;
for i = 1:2:length(varargin)
    switch varargin{i}
        case 'save_dir'
            save_dir = varargin{i+1};
            do_save = 1;
        case 'maxScale'
            maxscl = varargin{i+1};
            maxscl_comp = 0;
    end
end


Xrange = [this.aExtendMin(1) this.aExtendMax(1)]/this.psize(1);
Yrange = [this.aExtendMin(2) this.aExtendMax(2)]/this.psize(2);
x = this.X_voxel_rw(:,1);
y = this.X_voxel_rw(:,2);
mask = this.mask;
point_prob = sum(dens_pdf3d,3)./sum(mask,3);
point_prob(isnan(point_prob)) = 0;
point_prob = flipud(point_prob');



set(0,'defaulttextinterpreter','latex','DefaultAxesFontSize',20)
fig = figure(1);clf
T_aux = colormap(jet);
if maxscl_comp
    maxscl =max(point_prob(:));
end
cx_aux = linspace(0,maxscl,size(T_aux,1));
T = [1,1,1        %// white
    1,1,1        %// white
    T_aux];
cx = [-1 -0.1 cx_aux];
bonecmap = interp1((cx+1)/(maxscl+1),T,linspace(0,1,255));
PPDF1_cont = point_prob;

maskDAPIproj = flipud(max(mask,[],3)');
PPDF1_cont(maskDAPIproj==0) = -1;

% fig = figure;
imagesc(Xrange(1):Xrange(2),[Yrange(2) Yrange(1)],PPDF1_cont)
colormap(bonecmap)
caxis([-1, maxscl])
hc = colorbar('Location','eastoutside');
set(hc, 'ylim', [0,maxscl])

freezeColors
hold on
xlin = linspace(Xrange(1), Xrange(2),size(PPDF1_cont,2));
ylin = linspace(Yrange(2), Yrange(1),size(PPDF1_cont,1));
[Xlin,Ylin] = meshgrid(xlin,ylin);
contour(Xlin,Ylin,PPDF1_cont==-1,1,'Color','k','LineWidth',1);
% camorbit(0,180)
sca = 0.002;
scb = 40;
scatter_psize = scb*exp(-sca*length(x));
if scatter_psize >1e-6
    if scatter_psize < 10
        scatter_psize = 1;
    else
        scatter_psize = 5;
    end
    scatter(x,y,scatter_psize,'k','filled')
end

axis image
set(gca,'visible','off')


if do_save
    density_save_dir = [save_dir 'density_estimation\'];
    if exist(density_save_dir,'dir') == 0
        mkdir(density_save_dir);
    end
    saveas(fig,[density_save_dir 'cell_density_2Dproj.png']);
    saveas(fig,[density_save_dir 'cell_density_2Dproj.tiff']);
    saveas(fig,[density_save_dir 'cell_density_2Dproj.fig']);
    saveas(fig,[density_save_dir 'cell_density_2Dproj.pdf']);
end