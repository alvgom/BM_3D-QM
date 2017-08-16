function dist_pt2str = evalDTspots(this,maskDist,save_dir)

disp_fig = 1;
if nargin<3
    disp_fig = 0;
end
X =round(this.X_voxel0);
if size(X,2) == 3
    for dcc = 1:size(X,1)
        dist_pt2str(dcc) = maskDist(X(dcc,1),X(dcc,2),X(dcc,3));
    end
elseif size(X,2) == 2
    for dcc = 1:size(X,1)
        dist_pt2str(dcc) = maskDist(X(dcc,1),X(dcc,2));
    end
else
    error('This program only accept 2D and 3D data')
end

distSpots = dist_pt2str;
% Visualization
if disp_fig
    use_cont = 1;
    if isempty(this.mask)
        use_cont = 0;
    end
    mask = maskDist==0;
  
    complete_save_dir = [save_dir 'dist2sinusoids\'];
    if exist(complete_save_dir,'dir') == 0
        mkdir(complete_save_dir);
    end
    % 3D
    h1 = figure;
    min_mdist = 3;
    max_mdist = 40;
    mdist = (distSpots-min(distSpots))/(max(distSpots)-min(distSpots))*(max_mdist-min_mdist)+min_mdist;
    scatter3(X(:,1),X(:,2),X(:,3),mdist,distSpots,'filled')
    xlabel('x')
    ylabel('y')
    colormap(jet)
    colorbar
    title('Distance to closest sinusoid')
    saveas(h1,[complete_save_dir 'scatter3.png']);
    saveas(h1,[complete_save_dir 'scatter3.fig']);
    % 2D
    h2 = figure;
    scatter(X(:,1),X(:,2),mdist,distSpots,'filled')
    xlabel('x')
    ylabel('y')
    colormap(jet)
    colorbar
    title('Distance to closest sinusoid. 2D projection')
    saveas(h2,[complete_save_dir 'scatter2.png']);
    saveas(h2,[complete_save_dir 'scatter2.fig']);
    h3 = figure;
    imshow(sum(mask,3)',[])
    hold on
    if use_cont
%         this.maskContour_um
        contour(max(this.mask,[],3)',1,'Color','y','LineWidth',2)
    end
    scatter(X(:,1),X(:,2),mdist,'r','filled')
    saveas(h3,[complete_save_dir 'overlay_bw.png']);
    saveas(h3,[complete_save_dir 'overlay_bw.fig']);
    h4 = figure;
    % imagesc(sum(mask,3)')
    % truesize(h4,[size(mask,2) size(mask,1)])
    % colormap(gray)
    imshow(sum(mask,3)',[])
    hold on
    if use_cont
        contour(max(this.mask,[],3)',1,'Color','y','LineWidth',2)
%         this.maskContour_um
    end
    freezeColors
    scatter(X(:,1),X(:,2),mdist,distSpots,'filled')
    colormap(jet)
    colorbar
    caxis auto
    
    hgexport(h4, [complete_save_dir 'overlay_color.png'], hgexport('factorystyle'), 'Format', 'jpeg')
    saveas(h4,[complete_save_dir 'overlay_color.png']);
    saveas(h4,[complete_save_dir 'overlay_color.fig']);
    h5 = figure;
    hist(distSpots,20)
    xlabel('Distance from cell to closest sinusoid')
    ylabel('Frequency')
    title('Histogram of distances to closest sinusoid')
    saveas(h5,[complete_save_dir 'histogram.png'])
    saveas(h5,[complete_save_dir 'histogram.fig'])
    
    h6 = figure;
    D_extrav = distSpots;
    D_extrav(D_extrav==0) = [];
    hist(D_extrav,20)
    xlabel('Distance from cell to closest sinusoid')
    ylabel('Frequency')
    title('Histogram of distances to closest sinusoid (extravascular)')
    saveas(h6,[complete_save_dir 'histogram_extravascular.png'])
    saveas(h6,[complete_save_dir 'histogram_extravascular.fig'])
    close all
end
