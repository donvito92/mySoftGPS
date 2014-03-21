% This script plots the collective correlogram.

% Loop over the correlogram matrix and find out the NE search domain for
% the value of U and B that give maximum likelihood:
for i = 1 : size(CC, 1)
    for j = 1 : size(CC, 2)
        % This is the NE space we want to plot:
        mat(i,j) = CC(i, j, up, bias, coarseTime);
    end
end

% Plot the 3-D bar chart:
h = bar3(mat);

% Set the colors of the bars according to the height of the bars:
for k = 1:length(h)
    zdata = get(h(k),'ZData');
    set(h(k),'CData',zdata,...
             'FaceColor','interp')
end

% Set the limit of the axis:
axis([0.6 21.4 0.6 21.4 -Inf Inf]);
% Set the spacing of the ticks on N-axis:
set(gca, 'XTick', [1 3.5 6 8.5 11 13.5 16 18.5 21]);
% Set the label of the ticks on the N-axis:
set(gca, 'XTickLabel', [-roughEstimate.uncertaintyN -3*roughEstimate.uncertaintyN/4 -roughEstimate.uncertaintyN/2 -roughEstimate.uncertaintyN/4 0 roughEstimate.uncertaintyN/4 roughEstimate.uncertaintyN/2 3*roughEstimate.uncertaintyN/4 roughEstimate.uncertaintyN]);
% Set the spacing of the ticks on E-axis:
set(gca, 'YTick', [1 3.5 6 8.5 11 13.5 16 18.5 21]);
% Set the label of the ticks on the E-axis:
set(gca, 'YTickLabel', [-roughEstimate.uncertaintyE -3*roughEstimate.uncertaintyE/4 -roughEstimate.uncertaintyE/2 -roughEstimate.uncertaintyE/4 0 roughEstimate.uncertaintyE/4 roughEstimate.uncertaintyE/2 3*roughEstimate.uncertaintyE/4 roughEstimate.uncertaintyE]);
% N-axis label:
xlabel('Error North (meters)');
% E-axis label:
ylabel('Error East (meters)');
% Likelihood axis label:
zlabel('Likelihood');
% Title of the plot:
title(strcat('Collective correlogram for uncertainty of :', num2str(roughEstimate.uncertaintyN), ' meters.'));