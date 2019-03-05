function plot_errors_log_scale(type, aux, color, errors, lambda_max)

semilogy(errors, [color, '.']);
hold on

plot_title = ['Error of ', type, ' iterates'];

if ~isempty('aux')
    plot_title = [plot_title, aux];
end

title(plot_title);

semilogy(3 * lambda_max.^(1:length(errors)), 'k--');
hold off
legend([type, ' Error'], 'O(|\lambda_{max}|^k)');
xticks(0:50:length(errors));
xlabel('Iterations, k');
ylabel('Absolute Error (log scale)');