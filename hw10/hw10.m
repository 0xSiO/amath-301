clear; clc; close all;

%% Problem 1
% theta' = phi
% phi'     = -g/len * sin(theta)
g = 9.8;
len = 10;

% z = [theta; phi]
obj = @(z) [ z(2); -g/len * sin(z(1))];
z0 = [0; 3.1];
[t, z] = ode45(@(t, z) obj(z), 0:0.1:100, z0);

theta_sample = z(1:500, 1);
phi_sample = z(1:500, 2);

save('A1.dat', 'theta_sample', '-ascii');
save('A2.dat', 'phi_sample', '-ascii');

%% Problem 2
figure(1);
clf;
plot(t, z);
title('Physically Unrealistic Numerical Solution');
xlabel('Time (s)');
legend('Pendulum Angle (rad)', 'Angular Velocity (rad/s)');

print(gcf, '-dpng', 'non_conservative_pendulum.png');

%% Problem 3
figure(2);
clf;
[X, Y] = meshgrid(-6:0.5:6, -4:0.5:4);
quiver(X, Y, Y, -g/len * sin(X));
xlim([-6, 6]);
ylim([-4, 4]);
hold on

get_solution = @(z0) ode45(@(t, z) obj(z), 0:0.1:1000, z0);
plot_solution = @(sol) plot(sol(:, 1), sol(:, 2), '.');

[~, sol_1] = get_solution([1; 0]);
[~, sol_2] = get_solution([2; 0]);
[~, sol_3] = get_solution([3.1; 0]);
plot_solution(sol_1);
plot_solution(sol_2);
plot_solution(sol_3);

title('Phase Portrait with ode45 Trajectories');
xlabel('Pendulum Angle (rad)');
ylabel('Pendulum Angular Velocity (rad/s)');

print(gcf, '-dpng', 'pendulum_phase_ode45.png');

%% Problem 4
f_symp = @(t, x, v) v;
g_symp = @(t, x, v) -g/len * sin(x);
[t, x, v] = symplecticEuler(f_symp, g_symp, 0:0.1:100, 3.1, 0);

theta_sample = x(1:500);
phi_sample = v(1:500);

save('B1.dat', 'theta_sample', '-ascii');
save('B2.dat', 'phi_sample', '-ascii');

%% Problem 5
figure(3);
clf;
plot(t, x);
hold on
plot(t, v);
title('Energy-Conserving Numerical Solution');
xlabel('Time (s)');
legend('Pendulum Angle (rad)', 'Angular Velocity (rad/s)');

print(gcf, '-dpng', 'conservative_pendulum.png');

%% Problem 6
figure(4);
clf;
[X, Y] = meshgrid(-6:0.5:6, -4:0.5:4);
quiver(X, Y, Y, -g/len * sin(X));
xlim([-6, 6]);
ylim([-4, 4]);
hold on

get_solution = @(x0, v0) symplecticEuler(f_symp, g_symp, 0:0.1:1000, x0, v0);
plot_solution = @(x, v) plot(x, v, '.');

[~, x1, v1] = get_solution(1, 0);
[~, x2, v2] = get_solution(2, 0);
[~, x3, v3] = get_solution(3.1, 0);
plot_solution(x1, v1);
plot_solution(x2, v2);
plot_solution(x3, v3);

title('Phase Portrait with sympEuler Trajectories');
xlabel('Pendulum Angle (rad)');
ylabel('Pendulum Angular Velocity (rad/s)');

print(gcf, '-dpng', 'pendulum_phase_sympEuler_dt_0.1.png');

%% Problem 7
load('tprism_spec.mat');
F = calcSpringForces(nodes, springs);
save('C1.dat', 'F', '-ascii');

%% Problem 8
c = 5;
dXdt = @(t, x, v) v;
dVdt = @(t, x, v) calcSpringForces(x, springs) - c*v;

[t, x, v] = symplecticEuler(dXdt, dVdt, 0:0.01:50, nodes, zeros(size(nodes)));

save('D1.dat', 'x', '-ascii');
save('D2.dat', 'v', '-ascii');

%% Problem 9
final_pos = x(end, :);
[final_forces, springs_aug] = calcSpringForces(final_pos, springs);

%% Problem 10
Xrest = final_pos;
save('E1.dat', 'Xrest', '-ascii');
save('F1.dat', 'final_forces', '-ascii');

spring_lengths = springs_aug(:, end);
save('F2.dat', 'spring_lengths', '-ascii');

%% Problem 11
figure(5);
clf;
drawSpringMassSystem(Xrest, springs);
view([-10 30]);
print(gcf, '-dpng', 'tprism_side.png');
view([0 90]);
print(gcf, '-dpng', 'tprism_above.png');

