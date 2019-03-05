clear; clc; clf;

%% Problem 1
clf;
f = @(x, y) (x.^2 + y - 11).^2 + (x + y.^2 - 7).^2;
x = linspace(-5, 5, 31);
y = linspace(-5, 5, 31);
[X, Y] = meshgrid(x, y);
Z = f(X, Y);

surf(X, Y, Z);
title('Beale Function');
xlabel('x');
ylabel('y');
zlim([0, 500]);
caxis([0, 500]);
colorbar('eastoutside');
view(-70, 30);
daspect([1, 1, 100]);

print(gcf, '-dpng', 'beale_surf.png');

%% Problem 2
clf;
x = linspace(-7, 7, 100);
y = linspace(-6, 6, 100);
[X, Y] = meshgrid(x, y);
Z = f(X, Y);

contourf(X, Y, Z, 'LevelList', logspace(-1, 3, 21));
title('Contours of the Beale Function');
xlabel('x');
ylabel('y');
caxis([0, 500]);
colorbar('eastoutside');

print(gcf, '-dpng', 'beale_contour.png');

%% Problem 3
f_v = @(p) f(p(1), p(2));
result = f_v([1, 1]);
save('A1.dat', 'result', '-ascii');

%% Problem 4
f_grad = @(x, y) [4.*x.*(x.^2 + y - 11) + 2.*(x + y.^2 - 7)
                  2.*(x.^2 + y - 11) + 4.*y.*(x + y.^2 - 7)];
f_grad_v = @(p) f_grad(p(1), p(2));

result = f_grad_v([1, 1]);
inf_norm = norm(result, Inf);

save('A2.dat', 'result', '-ascii');
save('A3.dat', 'inf_norm', '-ascii');

%% Problem 5
p = [1; 1];
phi = @(t) p - t.*f_grad_v(p);
result_phi = phi(0.1);
result_f = f_v(result_phi);

save('A4.dat', 'result_phi', '-ascii');
save('A5.dat', 'result_f', '-ascii');

%% Problem 6
obj = @(t) f_v(phi(t));
t_min = fminbnd(obj, 0, 0.1);
phi_min = phi(t_min);

save('A6.dat', 't_min', '-ascii');
save('A7.dat', 'phi_min', '-ascii');

%% Problem 7
p = [1; 1];
for n = 1:1000
    % inline functions seem to preserve captured variables,
    % so redefine phi and obj here
    phi = @(t) p - t.*f_grad_v(p);
    obj = @(t) f_v(phi(t));
    t_min = fminbnd(obj, 0, 0.1);
    p = phi(t_min);
    
    if norm(f_grad_v(p), Inf) < 10^-4
        break;
    end
end

save('A8.dat', 'p', '-ascii');
save('A9.dat', 'n', '-ascii');

%% Problem 8
opts = optimset('TolFun', 1e-29);
[min_nw, f_min_nw] = fminsearch(f_v, [-3, 2], opts);
[min_sw, f_min_sw] = fminsearch(f_v, [-4, -2], opts);
[min_ne, f_min_ne] = fminsearch(f_v, [2, 2], opts);
[min_se, f_min_se] = fminsearch(f_v, [4, -3], opts);
mins = [min_ne.', min_nw.', min_sw.', min_se.'];

save('A10.dat', 'mins', '-ascii');

%% Problem 9
% Plot still exists at this point, just modify it
hold on
title('Minima of the Beale Function');
plot(mins(1, :), mins(2, :), 'ro', 'MarkerSize', 5);
plot(p(1), p(2), 'y*');

% Find global minimum
[val, index] = min([f_min_ne, f_min_nw, f_min_sw, f_min_se]);
global_min = mins(:, index);
plot(global_min(1), global_min(2), 'g+');

print(gcf, '-dpng', 'beale_minima.png');
