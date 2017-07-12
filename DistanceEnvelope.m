% Collect data
usr_continue=1;
count=0;
while usr_continue
    [FileName,PathName]=uigetfile('*.mat','Select another file or Cancel to stop');
    if ~isequal(FileName,0)
        count=count+1;
        load(fullfile(PathName,FileName));
        Cdist3d{count}=dist3d;
    else
        usr_continue=0;
    end
end

% Downsample data
vdist3d=cell(1,length(Cdist3d));
for i=1:length(Cdist3d)
    v_aux=Cdist3d{i}(:);
    drat = round(length(v_aux)/1000);
    vdist3d{i}=downsample(v_aux,drat);
end

% Display envelope
prcData = disp_envelopeCDF(vdist3d,'r',0,'std');