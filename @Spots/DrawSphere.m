function imData = DrawSphere(imData, aPos, aRad)
vSize = [size(imData, 1), size(imData, 2), size(imData, 3)];
% aPos = (aPos - aExtendMin) ./ (aExtendMax - aExtendMin) .* vSize + 0.5;
% aRad = aRad ./ (aExtendMax - aExtendMin) .* vSize;
vPosMin = round(max(aPos - aRad, 1));
vPosMax = round(min(aPos + aRad, vSize));
vPosX = vPosMin(1):vPosMax(1);
vPosY = vPosMin(2):vPosMax(2);
vPosZ = vPosMin(3):vPosMax(3);
[vX, vY, vZ] = ndgrid(vPosX, vPosY, vPosZ);
vDist = ((vX - aPos(1))/aRad(1)).^2 + ((vY - aPos(2))/aRad(2)).^2 + ...
    ((vZ - aPos(3))/aRad(3)).^2;
vInside = vDist < 1;
vCube = imData(vPosX, vPosY, vPosZ);
vCube(vInside) = 255;
imData(vPosX, vPosY, vPosZ) = vCube;
end