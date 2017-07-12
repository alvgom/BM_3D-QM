function Spots = getAllSpots(this)

Spots = {}; nObjs = 0;
aImarisApplication = this.aImarisApplication;
nChildren = aImarisApplication.GetSurpassScene().GetNumberOfChildren();
for i = 0 : (nChildren - 1)
    child = aImarisApplication.GetSurpassScene.GetChild( i );
    if aImarisApplication.GetFactory().IsSpots(child)
        nObjs = nObjs + 1;
        Spots{nObjs} = ...
            aImarisApplication.GetFactory().ToSpots(child);
    end
end