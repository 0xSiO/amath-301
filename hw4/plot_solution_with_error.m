function plot_solution_with_error(type, aux, color, t, x, true_x)

subplot(2, 1, 1);

plot_title = ['Solution by ', type, ' iteration'];

if ~isempty('aux')
    plot_title = [plot_title, aux];
end

title(plot_title);

hold on
plot(t, true_x, 'k.-', 'MarkerSize', 8);
plot(t, x, [color, 'o']);
hold off
xticks(0:0.5:pi);
ylabel('Solution');

subplot(2, 1, 2);
plot(t, abs(true_x - x), [color, 'o:']);
xticks(0:0.5:pi);
xlabel('t');
ylabel('Error');