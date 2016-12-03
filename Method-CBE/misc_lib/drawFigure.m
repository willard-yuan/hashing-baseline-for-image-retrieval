function drawFigure( method, res )
%DRAWFIGURE Summary of this function goes here
%   Detailed explanation goes here
%cc=hsv(length(method));
%cc=jet(length(method));

%cc=varycolor(length(method));
cc = distinguishable_colors(length(method));
h = figure('Position', [200 200 450 400]);
markers = {'+','o','*','.','x','s','d','^','v','>','<','p','h'};
hold on;
for i = 1:length(method)
    plot([10:10:100], res(i,:), 'color', cc(i,:), 'LineWidth',1.3, 'marker', markers{i});
end
ylabel('Recall');
xlabel('Number of retrieved points');
ylim([0 1]);
xlim([10 100]);
set(gca, 'XTick', 10:10:100)
grid on;
legend(method, 'location', 'SouthEast');
%print(h, sprintf('figure_%f.eps', now), '-depsc')

end