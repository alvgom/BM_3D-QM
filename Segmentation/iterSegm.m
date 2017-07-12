function volSeg = iterSegm(fun,vVol,prompt,defaultans,varargin)

do2D = 1;
do_initMask = 0;
maxsp = 2;
do_maskLim = 0;
for i = 1:2:length(varargin)
    switch varargin{i}
        case 'maskLim'
            do_maskLim = 1;
            maskLim = varargin{i+1};
            if isempty(maskLim)
                do_maskLim=0;
            end
        case 'do2D'
            do2D = varargin{i+1};
        case 'initMask'
            do_initMask = 1;
            initMask = varargin{i+1};
            maxsp = 3;
    end
end
            
slSel = round(size(vVol,3)/2);
up_param_sl = figure;
imshow(vVol(:,:,slSel),[])
title('Initial mask')

sel_slice = sprintf('Enter slice to display (1 - %d):',size(vVol,3));
prompt = [sel_slice, prompt];
defaultans = [{num2str(slSel)}, defaultans];

iter2D = 1;
while iter2D
    update_param = inputdlg(prompt,'Input',1,defaultans);
    defaultans = update_param;
    if isempty(update_param)
        error('The user interrupted the program');
    end
    param_in = [];
    slSel = str2num(update_param{1});
    for i = 1:length(update_param)-1
        param_in(i) = str2num(update_param{i+1});
    end
    
    % Segmentation 2D
    if do2D
        volSegAux = feval(fun,vVol(:,:,slSel),param_in,0);
    else
        volSegAux = feval(fun,vVol(:,:,slSel),param_in,1);
    end
    
    
    % Display
    close(up_param_sl)
    up_param_sl = figure('units','normalized','outerposition',[0 0 1 1]);
    nsp = 1;
    subplot(1,maxsp,1)
    imshow(vVol(:,:,slSel),[])
    hold on
    if do_maskLim
        contour(maskLim(:,:,slSel),1,'Color','y')
    end
    contour(volSegAux,1,'Color','r')
    title('Original signal')
    if do_initMask
        nsp = nsp+1;
        subplot(1,maxsp,nsp)
        imshow(initMask(:,:,slSel),[])
        if do_maskLim
            hold on
            contour(maskLim(:,:,slSel),1,'Color','y')
        end
        title('Initial mask')
    end
    nsp = nsp+1;
    subplot(1,maxsp,nsp)
    imshow(volSegAux,[])
    if do_maskLim
        hold on
        contour(maskLim,1,'Color','y')
    end
    title('Processed mask')
    update_q = questdlg('Do you want to change the parameters?',...
        'Update parameters',...
        'Yes', 'No','No');
    
    if isequal(update_q,'No')
        iter2D = 0;
        close(up_param_sl)
    end
end
volSeg = feval(fun,vVol,param_in);