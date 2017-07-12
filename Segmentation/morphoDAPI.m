function maskDAPI = morphoDAPI(vVol,param_in,do3D)

if nargin<2
    prompt = {'Enter sigma for Gaussian filter:','Enter threshold:','Enter opening size:','Enter closing size:', 'Enter maximum area to be filled:', 'Enter maximum area to be removed:'};
    thres_val = 20;
    close_size = 5;
    open_size = 5;
    sigma_Gaus = 5;
    fill_area = 8000;
    remove_area = 50000;
    defaultans = {num2str(sigma_Gaus),num2str(thres_val),num2str(open_size),num2str(close_size),num2str(fill_area),num2str(remove_area)};    
    
    do_bc = questdlg('Do you want to use border correction? (slower)','Question',...
        'Yes', 'No','No');
    if isequal(do_bc,'Yes')
        size_pad_aux = round(size(vVol)/2);
        size_pad = [size_pad_aux(1:2),0];
        vVol = padarray(vVol,size_pad,'symmetric');
    end
    maskDAPI = iterSegm('morphoDAPI',vVol,prompt,defaultans);
    if isequal(do_bc,'Yes')
        maskDAPI = maskDAPI(size_pad(1)+1:end-size_pad(1),size_pad(2)+1:end-size_pad(2),size_pad(3)+1:end-size_pad(3));
    end
else
    if nargin<3
        do3D = 1;
    end
    
    sigma_Gaus = param_in(1);
    thres_val = param_in(2);
    close_size = param_in(3);
    open_size = param_in(4);
    fill_area = param_in(5);
    remove_area = param_in(6);
    
    hGauss = fspecial('gaussian',sigma_Gaus,2*sigma_Gaus);
    se_open = strel('disk',open_size);
    se = strel('disk',close_size);
    
    if do3D
        parfor zz = 1:size(vVol,3)
            maskDAPI(:,:,zz) = morpho_segm(vVol(:,:,zz),hGauss,thres_val,se_open,se,fill_area,remove_area);
        end
    else
        maskDAPI = morpho_segm(vVol,hGauss,thres_val,se_open,se,fill_area,remove_area);
    end
end
end

function mask = morpho_segm(mask_init,hGauss,thres_val,se_open,se,fill_area,remove_area)
dapi_filt = imfilter(mask_init,hGauss);
maskVol = dapi_filt > thres_val;
mask = imopen(maskVol,se_open);
mask = imclose(mask,se);
mask = ~bwareaopen(~mask, fill_area);
mask = bwareaopen(mask, remove_area);
end