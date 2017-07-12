% Collect data
usr_continue=1;
count=0;
while usr_continue
    [FileName,PathName]=uigetfile('*.mat','Select another file or Cancel to stop');
    if ~isequal(FileName,0)
        count=count+1;
        load(fullfile(PathName,FileName));
        Cdist3d{count}=dist3d;
        CdistCell3d{count}=dist_cell2vessels;
    else
        usr_continue=0;
    end
end


% Downsample data
vdist3d=cell(1,length(Cdist3d));
vdistCell=cell(1,length(Cdist3d));
for i=1:length(Cdist3d)
    v_aux=Cdist3d{i}(:);
    v_auxCell=CdistCell3d{i}(:);
    drat = round(length(v_aux)/1000);
    drat2 = round(length(v_auxCell)/100);
    vdist3d{i}=downsample(v_aux,drat);
    vdistCell{i}=downsample(v_auxCell,drat2);
end

% Display envelope
figure(1), clf
prcData_Cell = disp_envelopeCDF(vdistCell,'g',1,'std');
title('Homogeneity test envelope');
xlim([0 40]);
hold on
prcData_3D = disp_envelopeCDF(vdist3d,'r',1,'std');
legend('From cell','','Empty space')