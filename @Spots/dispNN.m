function dispNN(this,save_dir)

NNdist = this.NNdist;
X = this.X_um_rw;
complete_save_dir = [save_dir 'NN\'];
if exist(complete_save_dir,'dir') == 0
    mkdir(complete_save_dir);
end
min_mdist = 5;
max_mdist = 50;
mdist = (NNdist-min(NNdist))/(max(NNdist)-min(NNdist))*(max_mdist-min_mdist)+min_mdist;
h2 = figure;
scatter3(X(:,1),X(:,2),X(:,3),mdist,NNdist,'filled')
xlabel('x')
ylabel('y')
zlabel('z')
colormap(jet)
colorbar
title('3D NN distance')
saveas(h2,[complete_save_dir 'scatter3.jpg']);
saveas(h2,[complete_save_dir 'scatter3.fig']);
h3 = figure;
scatter(X(:,1),X(:,2),mdist,NNdist,'filled')
xlabel('x')
ylabel('y')
colormap(jet)
colorbar
title('2D proyection of NN distance')
saveas(h3,[complete_save_dir 'scatter2.jpg']);
saveas(h3,[complete_save_dir 'scatter2.fig']);
h4 = figure;
hist(NNdist,50)
xlabel('NN distance')
ylabel('Frequency')
title('Histogram of NN distance')
saveas(h4,[complete_save_dir 'histogram.jpg']);
saveas(h4,[complete_save_dir 'histogram.fig']);
close all
end