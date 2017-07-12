function h = histogram_comparison(v1,v2)
h = figure;
nbins = 50;
h1 = histogram(v1,nbins);
hold on
h2 = histogram(v2,nbins);
h1.Normalization = 'probability';
h2.Normalization = 'probability';
