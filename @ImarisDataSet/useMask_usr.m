function mask = useMask_usr(this,mask_name)

if nargin<2
    mask_name = 'a';
end

use_mask = questdlg(['Do you want to use ' mask_name ' mask?'],...
    'Update parameters',...
    'Yes. Select', 'Yes. Create','No','No');
if isempty(use_mask)
    error('Please select one of the options available');
elseif isequal(use_mask,'Yes. Select')
    mask_message = ['Please select the channel with ' mask_name ' mask'];
    mask_channel = this.askuserChannel(mask_message);
    mask = this.GetVolume(mask_channel);
elseif isequal(use_mask,'No')
    switch mask_name
        case 'Vessels'
            mask = zeros(this.imsize);
        otherwise
            mask = ones(this.imsize);
    end
elseif isequal(use_mask,'Yes. Create')
    mask_message = ['Please select the channel with ' mask_name ' signal'];
    vVol_channel = this.askuserChannel(mask_message);
    vVol = this.GetVolume(vVol_channel);
    switch mask_name
        case 'DAPI'
            mask = morphoDAPI(vVol);
        case 'Vessels'
            sque_sinu = sprintf('Please select how do you want to start the segmentation. \nOption 1: Start with the original sinusoids signal. \nOption 2: Start with an already defined surface segmentation of the sinusoids wall.');
            segm_init = questdlg(sque_sinu,'Question',...
                'Option 1', 'Option 2','Option 2');
            if isequal(segm_init,'Option 1') %TODO
                mask = morphoVesselsThr(vVol);
            elseif isequal(segm_init,'Option 2')
                vSurf = this.GetObjects('ObjectType','surface','SelectObject',1);
                vSurf = vSurf{1};
                mask_init = this.SurfacetoMask(vSurf);
                mask = morphoVessels(mask_init);
            end
    end
    switch mask_name
        case 'DAPI'
            mask_color = [0 1 1 0];
        case 'Vessels'
            mask_color = [1 0 0 0];
        otherwise
            mask_color = [1 1 1 0];
    end
    nChannel_mask = this.SetNewChannel('ChannelName',[mask_name ' Mask'],'ChannelColor',mask_color);
    this.SetVolume(mask,nChannel_mask);
end