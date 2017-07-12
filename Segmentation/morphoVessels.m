function maskVessel = morphoVessels(vVol,param_in,do3D,maskLim)

do_maskLim = 1;
if nargin<4
    maskLim = [];
    do_maskLim = 0;
end
if nargin <2 || isempty(param_in)
    prompt = {'Enter radius for closing 1:','Enter radius for opening:','Enter radius for closing 2:','Enter maximum area to be filled:','Enter maximum area to be removed:'};
    vss_close = 15;
    vss_open = 0;
    vss_close2 = 0;
    fill_area = 5000;
    remove_area = 100;
    defaultans = {num2str(vss_close),num2str(vss_open),num2str(vss_close2),num2str(fill_area),num2str(remove_area)};
    do_bc = questdlg('Do you want to use border correction? (slower)','Question',...
        'Yes', 'No','No');
    if isequal(do_bc,'Yes')
        size_pad_aux = round(size(vVol)/2);
        size_pad = [size_pad_aux(1:2),0];
        vVol = padarray(vVol,size_pad,'symmetric'); 
    end
    maskVessel = iterSegm('morphoVessels',vVol,prompt,defaultans,'maskLim',maskLim);
    if isequal(do_bc,'Yes')
        maskVessel = maskVessel(size_pad(1)+1:end-size_pad(1),size_pad(2)+1:end-size_pad(2),size_pad(3)+1:end-size_pad(3));
    end
else
    if nargin<3
        do3D = 1;
    end
    SEclose1 = strel('disk',param_in(1));
    SEopen = strel('disk',param_in(2));
    SEclose2 = strel('disk',param_in(3));
    fill_area = param_in(4);
    remove_area = param_in(5);
    
    if do3D
        parfor kk = 1:size(vVol,3)
            vVol_out(:,:,kk) = morpho_segm(vVol(:,:,kk),SEclose1,SEopen,SEclose2,fill_area,remove_area);
        end
        radius = 1;
        [xgrid, ygrid, zgrid] = meshgrid(-radius:radius);
        SEball = (sqrt(xgrid.^2 + ygrid.^2 + zgrid.^2) <= radius);
        maskVessel = imclose(vVol_out,SEball);
        if do_maskLim
            maskVessel = maskVessel.*maskLim;
        end
    else
        maskVessel = morpho_segm(vVol,SEclose1,SEopen,SEclose2,fill_area,remove_area);
    end
end
end

function mask = morpho_segm(mask_init,SEclose1,SEopen,SEclose2,fill_area,remove_area)
% Morphological processing
mask_close1 = imclose(mask_init,SEclose1);
mask_open = imopen(mask_close1,SEopen);
mask_close2 = imclose(mask_open,SEclose2);
% Close with bwareaopen 3D
notopen_im = ~bwareaopen(~mask_close2, fill_area);
mask_filled_open = bwareaopen(notopen_im, remove_area);
% 2nd opening
% mask_filled_open = imopen(notopen_im,remove_area);
mask = mask_filled_open;
end

