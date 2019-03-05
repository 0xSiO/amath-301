clear; close all; clc;

f = @(x) x.^2 - 10;
f_deriv = @(x) 2*x;

% Problem 5
x = 1;
error = zeros(1, 20);
for j = 1:20
    error(j) = abs(sqrt(10) - x);
    x = x - (f(x) / f_deriv(x));
end
plot(1:20, error, 'ko', 'MarkerFaceColor', 'k');
title("Absolute error of Newton's method for \surd{10}");
xlabel("Iteration");
ylabel("Error | x_0 -- x |");
xticks(0:20);
yticks(0:0.25:2.5);

print(gcf, '-dpng', 'newton_error.png');

% Problem 6
clf
semilogy(1:20, error, 'ko', 'MarkerFaceColor', 'k');
title("Absolute error of Newton's method for \surd{10}");
xlabel("Iteration");
ylabel("Error | x_0 -- x | (Logarithmic scale)");
xticks(0:20);

print(gcf, '-dpng', 'newton_error_log.png');

% Problem 8
clf
xs = linspace(-1,6);
hold on
plot(xs, 0*xs, 'k-'); % x-axis
plot(xs, f(xs), 'b-'); % f(x)
plot(1, 0, 'rx'); % red cross on initial x

x_vals = ones(1, 20);
for j = 1:20
    x = x_vals(j);
    x_new = x - (f(x) / f_deriv(x));
    x_vals(j+1) = x_new;
    
    plot(x_new, 0, 'rx'); % red cross on x-axis
    plot(x, f(x), 'ro'); % red circle on f(x)
    plot([x x], [0 f(x)], 'r--'); % dashed vertical red line to f(x)
    plot([x x_new], [f(x), 0], 'r-'); % red line from f(x) to new x
end
print(gcf, '-dpng', 'newton_babylon_iterations.png');