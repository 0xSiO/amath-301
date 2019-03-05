clear; close all; clc;

% Problem 3
xs = linspace(-2*pi,2*pi);
f = @(x) 1 - x.^2 / 2;
clf
hold on
plot(xs,cos(xs), 'k', 'LineWidth', 3);
plot(xs,f(xs), 'r--', 'LineWidth', 2);

xlabel('Space, x');
title('Taylor Approximation of Cosine');
legend('cos(x)', '1 - x^2/2', 'Location', 'south');
xlim([-2*pi 2*pi]);
ylim([-3 1.5]);
xticks(-6:2:6);
yticks(-3:1);

print(gcf,'-dpng','plot_basic.png');