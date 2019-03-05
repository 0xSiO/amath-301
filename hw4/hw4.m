clear; close all; clc;

%% Problem 1
A = diag(-2 * ones(1, 30)) + diag(ones(1, 29), -1) + diag(ones(1, 29), 1);
t = linspace(0, pi, 30).';
b = cos(5 * t) + 1/2 * sin(7 * t);
true_x = A \ b;

save('A1.dat', 'A', '-ascii');
save('A2.dat', 'b', '-ascii');
save('A3.dat', 'true_x', '-ascii');

%% Problem 2
D = diag(diag(A));
T = A - D;
M = -D \ T;
g = D \ b;

[x, errors, lambda_max] = run_iterations(M, g, true_x, 400);

save('A4.dat', 'x', '-ascii');
save('A5.dat', 'errors', '-ascii');

%% Problem 3
save('A6.dat', 'lambda_max', '-ascii');

%% Problem 4
figure(1);
plot_solution_with_error('Jacobi', [], 'r', t, x, true_x);
print(gcf, '-dpng', 'solution_jacobi.png');

%% Problem 5
figure(2);
plot_errors_log_scale('Jacobi', [], 'r', errors, lambda_max);
print(gcf, '-dpng', 'errors_jacobi.png');

%% Problem 6
S = tril(A);
T = A - S;
M = -S \ T;
g = S \ b;

[x, errors, lambda_max] = run_iterations(M, g, true_x, 400);
save('A7.dat', 'x', '-ascii');
save('A8.dat', 'errors', '-ascii');
save('A9.dat', 'lambda_max', '-ascii');

%% Problem 7
figure(3);
plot_solution_with_error('Gauss-Seidel', [], 'g', t, x, true_x);
print(gcf, '-dpng', 'solution_GS.png');

%% Problem 8
figure(4);
plot_errors_log_scale('Gauss-Seidel', [], 'g', errors, lambda_max);
print(gcf, '-dpng', 'errors_GS.png');

%% Problem 9
L = tril(A, -1);
D = diag(diag(A));
U = triu(A, 1);
w = 1.5;

M = -(D + w*L) \ (w*U + (w - 1)*D);
g =  (D + w*L) \ (w*b);

[x, errors, lambda_max] = run_iterations(M, g, true_x, 400);

save('A10.dat', 'x', '-ascii');
save('A11.dat', 'errors', '-ascii');
save('A12.dat', 'lambda_max', '-ascii');

%% Problem 10
figure(5);
plot_solution_with_error('SOR', [': \omega = ', num2str(w)], 'b', t, x, true_x);
print(gcf, '-dpng', 'solution_SOR.png');

%% Problem 11
figure(6);
plot_errors_log_scale('SOR', [', \omega = ', num2str(w)], 'b', errors, lambda_max);
print(gcf, '-dpng', 'errors_SOR.png');

%% Problem 12
lambdas = zeros(1, 91);
omegas = linspace(1.0, 1.9, 91);
for n = 1:91
    w = omegas(n);
    M = -(D + w*L) \ (w*U + (w - 1)*D);
    eigenvals = eig(M);
    lambdas(n) = max(abs(eigenvals));
end

save('A13.dat', 'lambdas', '-ascii');

%% Problem 13
figure(7);
hold on
title('Predicted Decay of SOR Iterates');
plot(omegas, lambdas);
hold off
xlabel('Parameter \omega');
ylabel('|\lambda_{max}|');

print(gcf, '-dpng', 'SOR_rates.png');

%% Problem 14
[~, n] = min(lambdas);
best_w = omegas(n);

M = -(D + best_w*L) \ (best_w*U + (best_w - 1)*D);
g =  (D + best_w*L) \ (best_w*b);

[x, errors, lambda_max] = run_iterations(M, g, true_x, 400);
save('A14.dat', 'x', '-ascii');
save('A15.dat', 'errors', '-ascii');
save('A16.dat', 'lambda_max', '-ascii');

%% Problem 15
figure(8);
plot_errors_log_scale('SOR', [', \omega = ', num2str(best_w)], 'b', errors, lambda_max);
print(gcf, '-dpng', 'errors_SOR_optimal.png');
