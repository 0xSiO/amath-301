clear; close all; clc;

%% Problem 1
A = [-1/2 1 0 0 0 0 0 0 0 1/2 0 0 0 0 0
    -sqrt(3)/2 0 0 0 0 0 0 0 0 -sqrt(3)/2 0 0 0 0 0
    0 -1 1 0 0 0 0 0 0 0 -1/2 1/2 0 0 0
    0 0 0 0 0 0 0 0 0 0 -sqrt(3)/2 -sqrt(3)/2 0 0 0
    0 0 -1 1 0 0 0 0 0 0 0 0 -1/2 1/2 0
    0 0 0 0 0 0 0 0 0 0 0 0 -sqrt(3)/2 -sqrt(3)/2 0
    0 0 0 -1 1/2 0 0 0 0 0 0 0 0 0 -1/2
    0 0 0 0 -sqrt(3)/2 0 0 0 0 0 0 0 0 0 -sqrt(3)/2
    0 0 0 0 -1/2 -1 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 1 -1 0 0 0 0 0 0 -1/2 1/2
    0 0 0 0 0 0 0 0 0 0 0 0 0 sqrt(3)/2 sqrt(3)/2
    0 0 0 0 0 0 1 -1 0 0 0 -1/2 1/2 0 0
    0 0 0 0 0 0 0 0 0 0 0 sqrt(3)/2 sqrt(3)/2 0 0
    0 0 0 0 0 0 0 1 -1 -1/2 1/2 0 0 0 0
    0 0 0 0 0 0 0 0 0 sqrt(3)/2 sqrt(3)/2 0 0 0 0];
% I now realize I could have just done A = zeros(15, 15) and set the
% coefficients accordingly :(

save('A1.dat', 'A', '-ascii');

%% Problem 2
b = [0 0 0 0 0 0 0 0 0 0 800 0 900 0 13000].';
x = A \ b;
largest = max(abs(x));

save('A2.dat', 'x', '-ascii');
save('A3.dat', 'largest', '-ascii');

%% Problem 3
nodes = [0, 0.5:3.5, 4, 3, 2, 1; 0 1 1 1 1 0 0 0 0].';
beams = [1:9, 2, 9, 3, 8, 4, 7; 2:9, 1, 9, 3, 8, 4, 7, 5].';

clf; % clear the figure window
set(gcf,'position',[20 50 600 250],'paperpositionmode','auto')
hold on

for n = 1:15
    beam = beams(n, :);
    plot(nodes(beam, 1), nodes(beam, 2))
end

axis equal; % make aspect ratio 1:1
axis([-.5 4.5 -.5 1.5]);
print(gcf,'-dpng','truss_bridge_beams.png');

%% Problem 4
clf; % clear the figure window
set(gcf,'position',[20 50 600 250],'paperpositionmode','auto')
hold on

for n = 1:15
    beam = beams(n, :);
    if x(n) > 0
        color = 'g';
    else
        color = 'r';
    end
    
    plot(nodes(beam, 1), nodes(beam, 2), color, ...
        'LineWidth', abs(x(n) / 1000), ...
        'MarkerEdgeColor', 'k', 'Marker', '.', 'MarkerSize', 80)
end

axis equal; % make aspect ratio 1:1
axis([-.5 4.5 -.5 1.5]);
print(gcf,'-dpng','truss_bridge_forces.png');

%% Problem 5
[L, U, P] = lu(A);
save('A4.dat', 'L', '-ascii');
save('A5.dat', 'U', '-ascii');
save('A6.dat', 'P', '-ascii');

y = L \ (P * b);
save('A7.dat', 'y', '-ascii');

answer = U \ y;
save('A8.dat', 'answer', '-ascii');

%% Problem 6
for n = 1:10^5
    b(15) = b(15) + 0.1;
    forces = U \ (L \ (P * b));
    if max(abs(forces)) > 20000
        break
    end 
end
breaking_weight = b(15);
save('A9.dat', 'breaking_weight', '-ascii');
save('A10.dat', 'forces', '-ascii');

%% Problem 7
clf; % clear the figure window
set(gcf,'position',[20 50 600 250],'paperpositionmode','auto')
hold on

for n = 1:15
    beam = beams(n, :);
    if forces(n) > 0
        color = 'g';
    else
        color = 'r';
    end
    
    plot(nodes(beam, 1), nodes(beam, 2), color, ...
        'LineWidth', abs(forces(n) / 1000), ...
        'MarkerEdgeColor', 'k', 'Marker', '.', 'MarkerSize', 80)
end

axis equal; % make aspect ratio 1:1
axis([-.5 4.5 -.5 1.5]);
print(gcf,'-dpng','truss_bridge_breakingpoint_forces.png');
