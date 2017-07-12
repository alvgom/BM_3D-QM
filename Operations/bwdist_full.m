function volDist = bwdist_full(vVol,save_dir)

if nargin<2
    bvis = 0;
else
    bvis = 1;
end

vVol_aux = vVol;
vVol(isnan(vVol_aux)) = 0;
distpos = bwdist(vVol);
distpos(isnan(vVol_aux)) = nan;
vVol_neg = vVol<1;
vVol_neg(isnan(vVol_aux)) = 0;
distneg = bwdist(vVol_neg);
distneg(isnan(vVol_aux)) = nan;

volDist = distpos-distneg;
volDist(volDist<0) = volDist(volDist<0)+1;

if bvis
    fig = figure;
    midz = round(size(vVol,3)/2);
    x = 1:size(vVol,1);
    y = 1:size(vVol,2);
    [X, Y] = meshgrid(x,y);
    Z = vVol(:,:,midz);
    volFig = volDist(:,:,midz);
    minNeg = min(volFig(:));
    maxPos = max(volFig(:));
    volFig(isnan(volDist(:,:,midz))) = maxPos+maxPos/10;
    imshow(volFig',[])
    hold on
    contour(X,Y,Z','k')
    
    %Colormap
    T_pos = colormap(autumn);
    T_neg = colormap(winter);
    cx_neg = linspace(minNeg,-1,size(T_neg,1));
    cx_pos = linspace(1,maxPos,size(T_pos,1));
    T = [T_neg
        0 0 0
        0 0 0
        T_pos];
    cx = [cx_neg -0.9 0.9 cx_pos];
    cx_norm = (cx-min(cx))/(max(cx)-min(cx));
    bonecmap = interp1(cx_norm,T,linspace(0,1,255));
    bonecmap(end+1,:) = [1 1 1];
    colormap(bonecmap)
    colorbar
    
    if ~isempty(save_dir)
        saveas(fig,[save_dir 'distance_map_full.png']);
        saveas(fig,[save_dir 'distance_map_full.fig']);
    end
end