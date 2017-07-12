function mask_out = GetMask(this,nameMask)

use_mask = questdlg(['Do you want to use ' nameMask ' mask?'],...
    'Input',...
    'Yes. Select', 'Yes. Create','No','No');
if isempty(use_mask)
    error('Please select one of the options available');
elseif isequal(use_mask,'Yes. Select')
    usr_message = ['Please select the channel whith the ' nameMask ' mask'];
    mask_channel = this.askuserChannel(usr_message);
    mask_out = this.GetVolume(mask_channel);
elseif isequal(use_mask,'No')
    mask_out = ones(this.imsize);
elseif isequal(use_mask,'Yes. Create')
    switch nameMask
        case 'DAPI'
            usr_message = ['Please select the channel whith the ' nameMask ' signal'];
            nChannel_signal = this.askuserChannel(usr_message);
            vVol = this.GetVolume(nChannel_signal);
            mask_out = morphoDAPI(vVol);
        case 'vessels'
            sque_sinu = sprintf('Please select how do you want to start the segmentation. \nOption 1: Start with the original sinusoids signal. \nOption 2: Start with an already defined surface segmentation of the sinusoids wall.');
            segm_init = questdlg(sque_sinu,'Question',...
                'Option 1', 'Option 2','Option 2');
            
            inst_message_channel = 'Please choose channel with the sinusoids signal';
            if isequal(segm_init,'Option 1')
                error('New implementation in process...');
            elseif isequal(segm_init,'Option 2')
                vSurf = GetObjects(aImarisApplication,'ObjectType','surface','SelectObject',1);
                vSurf = vSurf{1};
                vVol = SurfacetoMask(iDataSet,vSurf);
                mask_out = morphoVessels(vVol);
            end
        case 'uCT'
            usr_message = ['Please select the channel whith the ' nameMask ' signal'];
            nChannel_signal = this.askuserChannel(usr_message);
            vVol = this.GetVolume(nChannel_signal);
            [mask_out,~] = morphoBM_uCT(vVol);
    end
end