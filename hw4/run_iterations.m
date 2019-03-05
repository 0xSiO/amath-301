function [x, errors, lambda_max] = run_iterations(M, g, true_x, num_iterations)

x = zeros(length(M), 1);
errors = zeros(num_iterations, 1);

for n = 1:num_iterations
    x = M*x + g;
    errors(n) = norm(true_x - x);
end

eigenvals = eig(M);
lambda_max = max(abs(eigenvals));