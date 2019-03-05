clear; clc; close all;

%% Problem 1
g = 9.8;
l = 10;
step = 0.01;
iterations = 50 / step;
A = [0 1; -g/l 0]; % Z' = A*Z

thsave_FE = zeros(iterations, 1);
phisave_FE = zeros(iterations, 1);

% initial conditions
thsave_FE(1) = 1;
phisave_FE(1) = 0;

z_next_FE = @(z) z + step*A*z; % Z(n+1) = Z(n) + dt*A*Z(n)

for n = 1:iterations
    z = z_next_FE([thsave_FE(n); phisave_FE(n)]);
    thsave_FE(n + 1) = z(1);
    phisave_FE(n + 1) = z(2);
end

save('A1.dat', 'thsave_FE', '-ascii');
save('A2.dat', 'phisave_FE', '-ascii');

%% Problem 2
thsave_BE = zeros(iterations, 1);
phisave_BE = zeros(iterations, 1);

% initial conditions
thsave_BE(1) = 1;
phisave_BE(1) = 0;

z_next_BE = @(z) (eye(2) - A*step) \ z; % Z(n) = (I - A*dt) \ Z(n-1)

for n = 1:iterations
    z = z_next_BE([thsave_BE(n); phisave_BE(n)]);
    thsave_BE(n + 1) = z(1);
    phisave_BE(n + 1) = z(2);
end

save('B1.dat', 'thsave_BE', '-ascii');
save('B2.dat', 'phisave_BE', '-ascii');

%% Problem 3
thsave_LF = zeros(iterations, 1);
phisave_LF = zeros(iterations, 1);

% initial conditions
thsave_LF(1) = 1;
phisave_LF(1) = 0;

% one iteration of forward Euler to get an extra point
z_first = z_next_FE([thsave_LF(1); phisave_LF(1)]);
thsave_LF(2) = z_first(1);
phisave_LF(2) = z_first(2);

z_next_LF = @(z_prev, z) z_prev + 2*step*A*z; % Z(n+2) = Z(n) + 2*dt*A*Z(n+1)

for n = 1:iterations-1 % already did one iteration
    z = z_next_LF([thsave_LF(n); phisave_LF(n)], [thsave_LF(n + 1); phisave_LF(n + 1)]);
    thsave_LF(n + 2) = z(1);
    phisave_LF(n + 2) = z(2);
end

save('C1.dat', 'thsave_LF', '-ascii');
save('C2.dat', 'phisave_LF', '-ascii');

%% Problem 4
[~, y] = ode45(@(t, y) A*y, linspace(0, 50, 5001), [1; 0]);
thsave_ODE45 = y(:, 1);
phisave_ODE45 = y(:, 2);

save('D1.dat', 'thsave_ODE45', '-ascii');
save('D2.dat', 'phisave_ODE45', '-ascii');

%% Problem 5
t = 0:step:50;
figure(1);
clf;
hold on
plot(t, thsave_FE, 'r', 'LineWidth', 1.5);
plot(t, thsave_LF, 'g', 'LineWidth', 1.5);
plot(t, thsave_BE, 'b', 'LineWidth', 1.5);
plot([0, 50], [1, 1], 'k--');
legend('Forward Euler', 'Leap Frog', 'Backward Euler', ...
       'Pendulum Amplitude', 'Location', 'northwest');
title('Numerical Solutions to Pendulum ODE');
xlabel('Time (s)');
ylabel('Pendulum Angle (rad)');

print(gcf, '-dpng', 'linear_pendulum_solutions.png');

%% Problem 6
[X, Y] = meshgrid(linspace(-2, 2, 21), linspace(-2, 2, 21));

figure(2);
clf;
quiver(X, Y, Y, -g/l*X);
xlim([-2, 2]);
ylim([-2, 2]);

hold on
plot(thsave_FE, phisave_FE, 'r');
plot(thsave_LF, phisave_LF, 'g', 'LineWidth', 2);
plot(thsave_BE, phisave_BE, 'b');
legend('Phase vector', 'Forward Euler', 'Leap Frog', 'Backward Euler');
title('Linear Phase Portrait of Solutions to Pendulum ODE');
xlabel('Pendulum Angle (rad)');
ylabel('Pendulum Angular Velocity (rad/s)');

print(gcf, '-dpng', 'linear_phase_portrait.png');

%% Problem 7
[~, y] = ode45(@(t, y) [y(2); -g/l*sin(y(1))], linspace(0, 50, 5001), [1; 0]);
thsave_ODE45 = y(:, 1);
phisave_ODE45 = y(:, 2);

save('E1.dat', 'thsave_ODE45', '-ascii');
save('E2.dat', 'phisave_ODE45', '-ascii');

%% Problem 8
[X, Y] = meshgrid(linspace(-2*pi, 2*pi, 25), -3:0.5:4);

figure(3);
clf;
quiver(X, Y, Y, -g/l*sin(X));
xlim([-2*pi, 2*pi]);
ylim([-3, 4]);
hold on

get_solution = @(y0) ode45(@(t, y) [y(2); -g/l*sin(y(1))], linspace(0, 50, 5001), y0);
plot_solution = @(sol) plot(sol(:, 1), sol(:, 2));

[~, sol_1] = get_solution([0.1; 0]);
[~, sol_2] = get_solution([1; 0]);
[~, sol_3] = get_solution([3; 0]);
[~, sol_4] = get_solution([-2*pi; 2.1]);
[~, sol_5] = get_solution([-2*pi; 3]);
plot_solution(sol_1);
plot_solution(sol_2);
plot_solution(sol_3);
plot_solution(sol_4);
plot_solution(sol_5);
title('Non-linear Phase Portrait of Solutions to Pendulum ODE');
xlabel('Pendulum Angle (rad)');
ylabel('Pendulum Angular Velocity (rad/s)');

print(gcf, '-dpng', 'nonlinear_phase_portrait.png');
