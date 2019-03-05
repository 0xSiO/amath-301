clear; close all; clc;

%% Problem 1
x_impact = @(theta) 0 + 100/9.8 * sin(2*theta);
[optimal_theta, distance] = fminbnd(@(theta) -1*x_impact(theta), 0, pi/2);
distance = abs(distance);

save('A1.dat', 'optimal_theta', '-ascii');
save('A2.dat', 'distance', '-ascii');

%% Problem 2
t_impact = @(theta) (-10*sin(theta) - sqrt((10*sin(theta))^2 + 2*9.8*10)) / -9.8;
x_impact = @(theta) 0 + 10*cos(theta)*t_impact(theta);
[optimal_theta_2, distance_2] = fminbnd(@(theta) -1*x_impact(theta), 0, pi/2);
distance_2 = abs(distance_2);

save('A3.dat', 'optimal_theta_2', '-ascii');
save('A4.dat', 'distance_2', '-ascii');

%% Problem 3
N = 30;
A = diag(-2 * ones(1, N)) + diag(ones(1, N - 1), -1) + diag(ones(1, N - 1), 1);
D = diag(diag(A));
L = tril(A) - D;
U = triu(A) - D;
M = @(w) -(D + w*L) \ (w*U + (w-1)*D);

largest_eig = @(w) max(abs(eig(M(w))));
[optimal_w, magnitude] = fminbnd(largest_eig, 1, 1.9);

save('A5.dat', 'optimal_w', '-ascii');
save('A6.dat', 'magnitude', '-ascii');