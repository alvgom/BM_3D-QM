function maskContour_um(this,varargin)

nfig = [];
contcolor = 'y';
contwidth = 2;
for i = 1:length(varargin)
    switch varargin{i}
        case 'FigureID'
            nfig = varargin{i+1};
        case 'Color'
            contcolor = varargin{i+1};
        case 'Width'
            contwidth = varargin{i+1};
    end
end
if isempty(nfig)
    figure(gcf);
else
    figure(nfig);
end

mask = this.mask;
maskcont2D = max(mask,[],3);
Xrange = [1 this.aExtendMax(1)-this.aExtendMin(1)];
Yrange = [1 this.aExtendMax(2)-this.aExtendMin(2)];
xlin = linspace(Xrange(1), Xrange(2),size(mask,1));
ylin = linspace(Yrange(1), Yrange(2),size(mask,2));
[Xlin,Ylin] = meshgrid(xlin,ylin);



contour(Xlin,Ylin,maskcont2D'==1,'Color',contcolor,'LineWidth',contwidth);
freezeColors;