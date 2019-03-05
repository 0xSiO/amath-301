clear; clc;
load('Plutonium.mat');

%% Problem 1
second_ord_central_diff = @(t, h) (Pdata(t + h) - Pdata(t - h))./(2*h);
estimate_1980 = second_ord_central_diff(11, 1);
save('A1.dat', 'estimate_1980', '-ascii');

%% Problem 2
second_ord_forward_diff = @(t, h) (-Pdata(t + 2*h) + 4.*Pdata(t + h) - 3.*Pdata(t))/(2*h);
estimate_1970 = second_ord_forward_diff(1, 1);
save('A2.dat', 'estimate_1970', '-ascii');

%% Problem 3
second_ord_backward_diff = @(t, h) (3.*Pdata(t) - 4.*Pdata(t - h) + Pdata(t - 2*h))/(2*h);
estimate_2010 = second_ord_backward_diff(41, 1);
save('A3.dat', 'estimate_2010', '-ascii');

%% Problem 4
all_derivs = [estimate_1970; second_ord_central_diff(2:40, 1); estimate_2010];
save('A4.dat', 'all_derivs', '-ascii');

%% Problem 5
get_decay_rate = @(t) -all_derivs(t)./Pdata(t);
all_decay_rates = get_decay_rate(1:41);
avg_decay_rate = mean(all_decay_rates);
save('A5.dat', 'avg_decay_rate', '-ascii');

%% Problem 6
half_life = log(2)/avg_decay_rate;
save('A6.dat', 'half_life', '-ascii');

%% Problem 7
predicted_decay = @(t) 1000.*exp(-avg_decay_rate.*(t - 1970));
t_vals = 1970:2010;

figure(1);
clf;
subplot(2, 1, 1);
hold on
plot(tdata, Pdata, 'k.', 'MarkerSize', 8);
plot(t_vals, predicted_decay(t_vals));
title('Radioactive Decay of Plutonium');
ylabel('Mass of Plutonium (kg)');
legend('Data', 'Exponential Decay');

subplot(2, 1, 2);
hold on
plot(1970:2010, predicted_decay(1970:2010).' - Pdata(1:41));
title('Error');
ylabel('Difference trom theory (kg)');
ylim([-0.03, 0.03]);
xlabel('Year');

print(gcf, '-dpng', 'plutonium_decay.png');

%% Problem 8
% µ = 1 and sigma^2 = 4
integrand = @(x) exp(-(x - 1).^2./(2.*4));
a = 2; b = 4;

first_sum = sum(integrand(a:b-1));
save('B1.dat', 'first_sum', '-ascii');

left_sums = zeros(17, 1);
for n = 0:16
    step = 2^-n;
    left_sums(n + 1) = sum(integrand(a:step:b-step)) .* step;
end
save('B2.dat', 'left_sums', '-ascii');

right_sums = zeros(17, 1);
for n = 0:16
    step = 2^-n;
    right_sums(n + 1) = sum(integrand(a+step:step:b)) .* step;
end
save('B3.dat', 'right_sums', '-ascii');

%% Problem 9
trap_sums = zeros(17, 1);
for n = 0:16
    step = 2^-n;
    trap_sums(n + 1) = step/2 * sum([integrand(a), 2*integrand(a+step:step:b-step), integrand(b)]);
end
save('B4.dat', 'trap_sums', '-ascii');

%% Problem 10
simp_sums = zeros(17, 1);
for n = 0:16
    step = 2^-n;
    simp_sums(n + 1) = step/3 * (sum(integrand(a:2*step:b-2*step)) + ...
                                 4*sum(integrand(a+step:2*step:b-step)) + ...
                                 sum(integrand(a+2*step:2*step:b)));
end
save('B5.dat', 'simp_sums', '-ascii');

%% Problem 11
true_value = integral(integrand, a, b);
save('B6.dat', 'true_value', '-ascii');

%% Problem 12
figure(2);
clf;
steps = logspace(0, log10(2^-16), 17);
loglog(steps, abs(left_sums - true_value), 'rx');
hold on
loglog(steps, abs(right_sums - true_value), 'bo');
loglog(steps, abs(trap_sums - true_value), 'g*');
loglog(steps, abs(simp_sums - true_value), 'ko');
title('Convergence of Quadrature Schemes');
ylabel('Error');
xlabel('Grid spacing \Delta{x}');

% order-of lines
loglog(steps, 2 * steps, 'k-', 'LineWidth', 2);
loglog(steps, 10^-2 * (steps .^ 2), 'k--', 'LineWidth', 2);
loglog(steps, 10^-4 * (steps .^ 4), 'k-.', 'LineWidth', 2);
loglog([10^-5, 1], [10^-16, 10^-16], 'LineWidth', 2); % machine precision line

legend('Left-rectangle', 'Right-rectangle', 'Trapezoid', "Simpson's rule", ...
       'O(h)', 'O(h^2)', 'O(h^4)', 'Machine precision', 'Location', 'se');

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 8 7];
print('quadrature_errors.png','-dpng','-r300')