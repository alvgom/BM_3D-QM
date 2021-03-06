function DataSpots = constructSpots(this,vSpots,mask)

if nargin<3
    mask = [];
end
if nargin<2 || isempty(vSpots)
    vSpots = this.GetObjects('ObjectType','spot','SelectObject',1);
    vSpots = vSpots{1};
end

DataSpots = Spots(vSpots.GetPositionsXYZ,...
    'aExtendMin',this.aExtendMin,...
    'aExtendMax',this.aExtendMax,...
    'psize',this.psize,...
    'mask',mask,...
    'radius_um',mean(vSpots.GetRadii));
