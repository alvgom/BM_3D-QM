function pval = CSRtestDT(volDT,feature_vector,save_dir)
%
% Complete Spatial Randomness (CSR) test of the distance transform to a defined structure.
%
% SYNOPSIS
%
%   pval = CSRtestDT(struct_mask,feature_vector)
%   pval = CSRtestDT(struct_mask,feature_vector,save_dir)
%
% INPUT
%
%   struct_mask:    structure defined by a binary mask to which the
%   distance transform is calculated
%   feature_vector: vector defining the distance from the observed points
%   to the structure of interest
%   save_dir: (optional) folder where the data produced is saved. If empty,
%   no images are produced and data is not saved
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

v_dist_vox2sinu = volDT(:);
v_dist_vox2sinu = v_dist_vox2sinu(~isnan(v_dist_vox2sinu));
[dec_kshyph,pval] = kstest2(feature_vector,v_dist_vox2sinu);

if save_data
    h_kstest = figure;
    cdfplot(v_dist_vox2sinu);
    hold on
    cdfplot(feature_vector);
    legend('f evaluated at all locations','f evaluated at cells')
    xlabel('Distance (\mum)')
    ylabel('Empirical CDF')
    string_pvalueks = sprintf('f: distance to closest sinusoid \nRejected with p-value: %0.2d',pval);
    title(string_pvalueks);
    complete_save_dir = [save_dir '\HomogeneityTest\'];
    if exist(complete_save_dir,'dir') == 0
        mkdir(complete_save_dir);
    end
    save([complete_save_dir 'kstest'],'dec_kshyph','pval','feature_vector','v_dist_vox2sinu');
    saveas(h_kstest,[complete_save_dir 'kstest_dist2sinu.png']);
    saveas(h_kstest,[complete_save_dir 'kstest_dist2sinu.fig']);
    
%     h_hist_kstest = figure;
%     [hist_dist_cell2sinu, hist_x] = hist(feature_vector,20);
%     [hist_dist_vox2sinu, hist_vox_x] = hist(v_dist_vox2sinu,20);
%     plot(hist_vox_x,hist_dist_vox2sinu/sum(hist_dist_vox2sinu));
%     hold on
%     plot(hist_x, hist_dist_cell2sinu/sum(hist_dist_cell2sinu),'r');
%     xlabel('Distance (\mum)')
%     ylabel('Empirical PDF')
%     title('Histogram of distances to closest sinusoid')
%     legend('f evaluated at all locations','f evaluated at cells')
    
    
    h_hist_kstest = histogram_comparison(feature_vector,v_dist_vox2sinu);
    figure(h_hist_kstest)
    xlabel('Distance (\mum)')
    ylabel('Empirical PDF')
    title('Histogram of distances to closest sinusoid')
    legend('f evaluated at cells','f evaluated at all locations')
    saveas(h_hist_kstest,[complete_save_dir 'hist_dist2sinu.png']);
    saveas(h_hist_kstest,[complete_save_dir 'hist_dist2sinu.fig']);
end