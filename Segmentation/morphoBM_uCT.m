function [outVol,Bone] = morphoBM_uCT(vVol,param_in,do3D)

if nargin<2
    prompt = {'Enter threshold:','Enter radius for closing 1:','Enter maximum area to be removed:','Enter radius for opening:','Enter radius for closing 2:','Enter maximum area to be filled:'};
    thr_level = 22000;
    vss_close = 0;
    vss_open = 0;
    vss_close2 = 5;
    fill_area = 100000;
    remove_area = 10;
    defaultans = {num2str(thr_level),num2str(vss_close),num2str(remove_area),num2str(vss_open),num2str(vss_close2),num2str(fill_area)};
    outVol = iterSegm('morphoBM_uCT',vVol,prompt,defaultans);
    % 3D closing
    radius = 3;
    [xgrid, ygrid, zgrid] = meshgrid(-radius:radius);
    SEball = (sqrt(xgrid.^2 + ygrid.^2 + zgrid.^2) <= radius);
    mask_filled_close3D = imclose(outVol,SEball);
    vVolCont = double(vVol).*(mask_filled_close3D>0);
    Bone = vVolCont>thr_level;
    vCont = mask_filled_close3D;
    SEerod = strel('disk',6);
    parfor kk = 1:size(vCont,3)
        vContErod(:,:,kk) = imerode(vCont(:,:,kk),SEerod);
    end
    % BM = vVolCont&(~Bone).*vContErod;
    BM = ((~Bone).*vContErod) > 0;
    outVol = BM;
else
    if nargin<3
        do3D = 1;
    end
    
    thr_level = param_in(1);
    vss_close = param_in(2);
    remove_area = param_in(3);
    vss_open = param_in(4);
    vss_close2 = param_in(5);
    fill_area = param_in(6);
    
    SEclose1 = strel('disk',vss_close);
    SEopen = strel('disk',vss_open);
    SEclose2 = strel('disk',vss_close2);
    
    if do3D
        mask_init = vVol > thr_level;
        parfor kk = 1:size(mask_init,3)
            outVol(:,:,kk) = morpho_segm(mask_init(:,:,kk),SEclose1,SEopen,SEclose2,fill_area,remove_area);
        end
        
    else
        mask_init = vVol > thr_level;
        outVol = morpho_segm(mask_init,SEclose1,SEopen,SEclose2,fill_area,remove_area);
    end
end
end

function mask = morpho_segm(mask_init,SEclose1,SEopen,SEclose2,fill_area,remove_area)
% Morphological processing
mask_close1 = imclose(mask_init,SEclose1);
mask_filled_open = bwareaopen(mask_close1, remove_area);
mask_open = imopen(mask_filled_open,SEopen);
mask_close2 = imclose(mask_open,SEclose2);
% Close with bwareaopen 3D
notopen_im = ~bwareaopen(~mask_close2, fill_area);
% 2nd opening
% mask_filled_open = imopen(notopen_im,remove_area);
mask = notopen_im;

end