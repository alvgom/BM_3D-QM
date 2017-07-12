function prcData = disp_envelopeCDF(C_distr,scolor,hold_fig,envelope)
% C_distr is a cell array with a sample distribution in each cell

if nargin<4
    envelope = 'std';
end
if nargin<3
    hold_fig = 0;
end
for i = 1:length(C_distr)
    aux = C_distr{i};
    C_distr_corr{i} = aux(~isnan(aux));
    
    [C_CDF{i},C_x{i}] = ecdf(C_distr_corr{i});
    C_CDF{i} = C_CDF{i}(2:end);
    C_x{i} = C_x{i}(2:end);
    
    lC(i) = length(C_CDF{i});
    maxval(i) = max(C_x{i});
end

% Percentiles
for j = 1:length(C_distr_corr)
    prcData.p25(j) = prctile(C_distr_corr{j},25);
    prcData.p50(j) = prctile(C_distr_corr{j},50);
    prcData.p75(j) = prctile(C_distr_corr{j},75);
    prcData.p95(j) = prctile(C_distr_corr{j},95);
end

minlen = min(lC);
maxlen = max(lC);
x_samp = linspace(0,max(maxval), maxlen);

distCDF = nan(maxlen,length(C_CDF));
for i = 1:length(C_CDF)
    distCDF(:,i) = interp1(C_x{i},C_CDF{i},x_samp);
end
corrpos_aux = isnan(distCDF);
for i = 1:size(distCDF,1)
    for j = 1:size(distCDF,2)
        if isnan(distCDF(i,j))
            tmp_pos =find(C_CDF{j}<0.5);
            if isempty(tmp_pos)
                tmp_pos = find(min(C_CDF{j}));
            end
            t50 = C_x{j}(tmp_pos(end));
            distCDF(i,j) = i>t50;
        end
    end
end
    
% distCDF(isnan(distCDF)) = find(isnan(distCDF))>size(distCDF,1)/2;
% Compensate problems in interpolation
for i = 1:length(C_CDF)
    if distCDF(end,i) < 1
        distCDF(end,i) = 1;
    end
end



Fmax = max(distCDF,[],2);
Fmean = mean(distCDF,2);
Fmin = min(distCDF,[],2);
Fstd = std(distCDF,[],2);
Fmaxstd = Fmean + Fstd;
Fminstd = Fmean - Fstd;

if hold_fig
    figure(1);
else
    figure;
end
if isequal(envelope,'std')
    fill([x_samp fliplr(x_samp)],[Fmaxstd', fliplr(Fminstd')],scolor,'FaceAlpha',0.4,'EdgeColor','none');
elseif isequal(envelope,'all')
    fill([x_samp fliplr(x_samp)],[Fmax', fliplr(Fmin')],scolor,'FaceAlpha',0.4,'EdgeColor','none');
else
    error('Insert a valid option for envelope');
end

hold on
plot(x_samp,Fmean,'--','Color','k')
ylim([0,1.05])
xlabel('Distance (\mum)','Interpreter','tex')
ylabel('CDF')
