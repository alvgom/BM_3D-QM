function pval = CSRtest_structures(distVol0,maskVolEval,save_dir)
%
% Complete Spatial Randomness (CSR) test of distance between defined structures.
%
% SYNOPSIS
%
%   pval = CSRtest_structures(struct_mask,feature_vector)
%   pval = CSRtest_structures(struct_mask,feature_vector,save_dir)
%
% INPUT
%
%   distVol0: distance transform to structure which defines H0
%   maskVolEval: mask with the structure to be evaluated
%
% OUTPUT
%
%   pval: p-value at which the null hypothesis of CSR can be rejected

% Author: Alvaro Gomariz Carrillo

if nargin < 3
    save_data = 0;
else
    save_data = 1;
end

v_dist_vox2sinu = distVol0(:);
feature_vector = v_dist_vox2sinu(maskVolEval(:)>0);
v_dist_vox2sinu = v_dist_vox2sinu(~isnan(v_dist_vox2sinu));
feature_vector = feature_vector(~isnan(feature_vector));
[dec_kshyph,pval] = kstest2(v_dist_vox2sinu,feature_vector);

if save_data
    h_kstest = figure;
    cdfplot(v_dist_vox2sinu);
    hold on
    cdfplot(feature_vector);
    legend('f evaluated at all locations','f evaluated at cells')
    xlabel('Distance (\mum)','Interpreter','tex')
    ylabel('Empirical CDF')
    string_pvalueks = sprintf('f: distance to closest sinusoid \nRejected with p-value: %0.2d',pval);
    title(string_pvalueks);
    if exist(save_dir,'dir') == 0
        mkdir(save_dir);
    end
    save([save_dir 'kstest'],'dec_kshyph','pval','feature_vector','v_dist_vox2sinu');
    saveas(h_kstest,[save_dir 'kstest_dist2sinu.png']);
    saveas(h_kstest,[save_dir 'kstest_dist2sinu.fig']);
    
    h_hist_kstest = figure;
    [hist_dist_cell2sinu, hist_x] = hist(feature_vector,20);
    [hist_dist_vox2sinu, hist_vox_x] = hist(v_dist_vox2sinu,20);
    plot(hist_vox_x,hist_dist_vox2sinu/sum(hist_dist_vox2sinu));
    hold on
    plot(hist_x, hist_dist_cell2sinu/sum(hist_dist_cell2sinu),'r');
    xlabel('Distance (\mum)','Interpreter','tex')
    ylabel('Empirical PDF')
    title('Histogram of distances to closest sinusoid')
    legend('f evaluated at all locations','f evaluated at cells')
    saveas(h_hist_kstest,[save_dir 'hist_dist2sinu.png']);
    saveas(h_hist_kstest,[save_dir 'hist_dist2sinu.fig']);
end