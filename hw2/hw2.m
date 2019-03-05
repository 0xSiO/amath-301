clear; close all; clc;

% Problem 1
f = @(x) x.*exp(x) - 5;

root = fzero(f, 1);
save('A1.dat', 'root', '-ascii');

% Problem 2
f = @(x) x.^2 - 10;
f_deriv = @(x) 2*x;

root = fzero(f, 3);
save('A2.dat', 'root', '-ascii');

% Problem 3
x = 1;
for j = 1:20
    x = x - (f(x) / f_deriv(x));
end
save('A3.dat', 'x', '-ascii');

% Problem 4
x_vals = ones(1, 20);
for j = 1:20
    x = x_vals(j);
    x_vals(j+1) = x - (f(x) / f_deriv(x));
end
x_vals = x_vals.';
save('A4.dat', 'x_vals', '-ascii');

% Problem 7
x_vals = [1];
for j = 1:20
    x = x_vals(j);
    x_new = x - (f(x) / f_deriv(x));
    x_vals(j+1) = x_new; 
    
    if abs(f(x_new)) < 10^-8
        break
    end
end
x_vals = x_vals.';
save('A5.dat', 'x_vals', '-ascii');
