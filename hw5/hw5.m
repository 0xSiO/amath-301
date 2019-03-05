clear; close all; clc;
load('CO2_data.mat');

%% Problem 1
sum_t = sum(t);
M_fitlinear = [sum(t .^ 2), sum_t; sum_t, length(t)];
b_fitlinear = [sum(t .* y); sum(y)];
coeffs_fitlinear = M_fitlinear \ b_fitlinear;

save('A1.dat', 'M_fitlinear', '-ascii');
save('A2.dat', 'b_fitlinear', '-ascii');
save('A3.dat', 'coeffs_fitlinear', '-ascii');

%% Problem 2
y_fitlinear = @(t) coeffs_fitlinear(1) * t + coeffs_fitlinear(2);

figure(1);
subplot(2, 1, 1);
hold on
title('Linear Fit');
plot(t, y, 'k.', 'MarkerSize', 6, 'LineStyle', '-');
set(gca, 'box', 'on');
% Don't need as many points
plot(0:5:65, y_fitlinear(0:5:65), 'Color', [1, 0.5, 0], 'LineWidth', 2);
set(gca, 'box', 'on');
legend('Data', 'Fit Curve', 'Location', 'northwest');
xlabel('Years since 1958');
xlim([0, 65]);
ylabel('Atmospheric CO_2');

subplot(2, 1, 2);
hold on
title('Error in Data Fit');
plot(0:20, zeros(1, 21), 'Color', [1, 0.5, 0], 'LineWidth', 2);
plot(t, y_fitlinear(t) - y, 'k.', 'MarkerSize', 6, 'LineStyle', '-');
set(gca, 'box', 'on');
xlabel('Years since 1958');
xlim([0, 20]);
ylabel('Fit Error');

print(gcf, '-dpng', 'co2_fit_linear.png');

%% Problem 3
sums = [sum(t), sum(t .^ 2), sum(t .^ 3), sum(t .^ 4)];
M_fitquadratic = [sums(4), sums(3), sums(2);
                  sums(3), sums(2), sums(1);
                  sums(2), sums(1), length(t)];
b_fitquadratic = [sum((t .^ 2) .* y); sum(t .* y); sum(y)];
coeffs_fitquadratic = M_fitquadratic \ b_fitquadratic;

save('A4.dat', 'M_fitquadratic', '-ascii');
save('A5.dat', 'b_fitquadratic', '-ascii');
save('A6.dat', 'coeffs_fitquadratic', '-ascii');

%% Problem 4
y_fitquadratic = @(t) coeffs_fitquadratic(1) * (t .^ 2) + ...
    coeffs_fitquadratic(2) * t + coeffs_fitquadratic(3);

figure(2);
subplot(2, 1, 1);
hold on
title('Quadratic Fit');
plot(t, y, 'k.', 'MarkerSize', 6, 'LineStyle', '-');
set(gca, 'box', 'on');
% Don't need as many points
plot(0:5:65, y_fitquadratic(0:5:65), 'Color', [0, 0.5, 1], 'LineWidth', 2);
set(gca, 'box', 'on');
legend('Data', 'Fit Curve', 'Location', 'northwest');
xlabel('Years since 1958');
xlim([0, 65]);
ylabel('Atmospheric CO_2');

subplot(2, 1, 2);
hold on
title('Seasonal Variation');
plot(0:20, zeros(1, 21), 'Color', [0, 0.5, 1], 'LineWidth', 2);
plot(t, y_fitquadratic(t) - y, 'k.', 'MarkerSize', 6, 'LineStyle', '-');
set(gca, 'box', 'on');
xlabel('Years since 1958');
xlim([0, 20]);
ylabel('Variation Around Mean');

print(gcf, '-dpng', 'co2_fit_quad.png');

%% Problem 5
sums = [sum(t), sum(t .^ 2), sum(t .^ 3), sum(t .^ 4), ...
        sum(sin(2 * pi .* t)), sum(sin(2 * pi .* t) .* t), sum(sin(2 * pi .* t) .* (t .^ 2))];
M_fitquadsinu = [sums(4), sums(3), sums(2), sums(7);
                 sums(3), sums(2), sums(1), sums(6);
                 sums(2), sums(1), length(t), sums(5);
                 sums(7), sums(6), sums(5), sum(sin(2 * pi .* t) .^ 2)];
b_fitquadsinu = [sum((t .^ 2) .* y); sum(t .* y); sum(y); sum(sin(2 * pi .* t) .* y)];
coeffs_fitquadsinu = M_fitquadsinu \ b_fitquadsinu;

save('A7.dat', 'M_fitquadsinu', '-ascii');
save('A8.dat', 'b_fitquadsinu', '-ascii');
save('A9.dat', 'coeffs_fitquadsinu', '-ascii');

%% Problem 6
y_fitquadsinu = @(t) coeffs_fitquadsinu(1) * (t .^ 2) + ...
    coeffs_fitquadsinu(2) * t + coeffs_fitquadsinu(3) + ...
    coeffs_fitquadsinu(4) * sin(2 * pi * t);
y_fitquadsinu_values = y_fitquadsinu(t);

figure(3);
subplot(2, 1, 1);
hold on
title('Quadratic + Sinusoidal Fit');
plot(t, y, 'k.', 'MarkerSize', 6, 'LineStyle', '-');
set(gca, 'box', 'on');
plot(0:0.1:65, y_fitquadsinu(0:0.1:65), 'Color', [0, 0.8, 0], 'LineWidth', 2);
set(gca, 'box', 'on');
legend('Data', 'Fit Curve', 'Location', 'northwest');
xlabel('Years since 1958');
xlim([0, 65]);
ylabel('Atmospheric CO_2');

subplot(2, 1, 2);
hold on
title('Error in Data Fit');
plot(0:20, zeros(1, 21), 'Color', [0, 0.8, 0], 'LineWidth', 2);
plot(t, y_fitquadsinu_values - y, 'k.', 'MarkerSize', 6, 'LineStyle', '-');
set(gca, 'box', 'on');
xlabel('Years since 1958');
xlim([0, 20]);
ylabel('Fit Error');

print(gcf, '-dpng', 'co2_fit_quadsinu.png');

%% Problem 7
exponential_fit = @(A, B, C, x) exp(A * (x - B)) + C;
exponential_fit_error = @(params) 1/2 * sum((exponential_fit(params(1), params(2), params(3), t) - y) .^ 2);
guess = [0.03, -100, 300];
opts = optimset('MaxFunEvals', 3000, 'MaxIter', 2000); % push it, push it, to the limit, limit
p_bestfit = fminsearch(exponential_fit_error, guess).';

A = p_bestfit(1);
B = p_bestfit(2);
C = p_bestfit(3);

averages = [exponential_fit(A, B, C, -58);
            exponential_fit(A, B, C, 0);
            exponential_fit(A, B, C, 62)];
        
save('A10.dat', 'p_bestfit', '-ascii');
save('A11.dat', 'averages', '-ascii');

%% Problem 8
y_fitexp = @(t) exponential_fit(A, B, C, t);

figure(4);
subplot(2, 1, 1);
hold on
title('Exponential Fit');
plot(t, y, 'k.', 'MarkerSize', 6, 'LineStyle', '-');
set(gca, 'box', 'on');
% Don't need as many points
plot(0:5:65, y_fitexp(0:5:65), 'Color', [0.75, 0, 1], 'LineWidth', 2);
set(gca, 'box', 'on');
legend('Data', 'Fit Curve', 'Location', 'northwest');
xlabel('Years since 1958');
xlim([0, 65]);
ylabel('Atmospheric CO_2');

subplot(2, 1, 2);
hold on
title('Seasonal Variation');
plot(0:20, zeros(1, 21), 'Color', [0.75, 0, 1], 'LineWidth', 2);
plot(t, y_fitexp(t) - y, 'k.', 'MarkerSize', 6, 'LineStyle', '-');
set(gca, 'box', 'on');
xlabel('Years since 1958');
xlim([0, 20]);
ylabel('Variation Around Mean');

print(gcf, '-dpng', 'co2_fit_exp.png');

%% Problem 9
exposoid_fit = @(A, B, C, D, E, F, x) exp(A * (x - B)) + C + D * sin(E * (x - F));
exposoid_fit_error = @(params) 1/2 * sum((exposoid_fit(params(1), ...
    params(2), params(3), params(4), params(5), params(6), t) - y) .^ 2);
guess = [0.03, -100, 300, 3, 2 * pi, 0];
p_bestfit = fminsearch(exposoid_fit_error, guess, opts).';

A = p_bestfit(1);
B = p_bestfit(2);
C = p_bestfit(3);
D = p_bestfit(4);
E = p_bestfit(5);
F = p_bestfit(6);
y_fitexposoid = @(x) exposoid_fit(A, B, C, D, E, F, x);

levels_each_month = y_fitexposoid(2020 - 1958 + (0:11).' / 12);

save('A12.dat', 'p_bestfit', '-ascii');
save('A13.dat', 'levels_each_month', '-ascii');

%% Problem 10
y_fitexposoid_values = y_fitexposoid(t);

figure(5);
subplot(2, 1, 1);
hold on
title('Exponential + Sinusoidal Fit');
plot(t, y, 'k.', 'MarkerSize', 6, 'LineStyle', '-');
set(gca, 'box', 'on');
plot(0:0.1:65, y_fitquadsinu(0:0.1:65), 'Color', [1, 0, 0.25], 'LineWidth', 2);
set(gca, 'box', 'on');
legend('Data', 'Fit Curve', 'Location', 'northwest');
xlabel('Years since 1958');
xlim([0, 65]);
ylabel('Atmospheric CO_2');

subplot(2, 1, 2);
hold on
title('Error in Data Fit');
plot(0:20, zeros(1, 21), 'Color', [1, 0, 0.25], 'LineWidth', 2);
plot(t, y_fitexposoid_values - y, 'k.', 'MarkerSize', 6, 'LineStyle', '-');
set(gca, 'box', 'on');
xlabel('Years since 1958');
xlim([0, 20]);
ylabel('Fit Error');

print(gcf, '-dpng', 'co2_fit_expsinu.png');