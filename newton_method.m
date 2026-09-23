%-------------------------------------------------------------------------%
%--------------------- NEWTON'S OPTIMIZATION METHOD ----------------------%
%-------------------------------------------------------------------------%
clear, clc, close all

syms x
%f_sym = 0.65 - 0.75/(1+x^2) -0.65*x*atan(1/x);
f_sym = -(1 / (x - 1)^2) * (log(x) - 2 * (x - 1) / (x + 1));
df_sym = diff(f_sym);
d2f_sym = diff(f_sym, 2);

f = matlabFunction(f_sym, 'Vars', x);
df = matlabFunction(df_sym, 'Vars', x);
d2f = matlabFunction(d2f_sym, 'Vars', x);

x_guess = 1.5;
tol = 0.001;
iter = 0;

df_eval = df(x_guess);
f_eval = f(x_guess);
d2f_eval_initial = d2f(x_guess);

% --- Track History for the Global View ---
x_hist = x_guess;
f_hist = f_eval;

% Updated console header
fprintf('===========================================================\n');
fprintf(" i | x_guess |    f(x)   |   f'(x)   |  f''(x)  \n");
fprintf('-----------------------------------------------------------\n');
fprintf('%2d | %7.4f | %9.7f | %9.4f | %9.4f \n', iter, x_guess, f_eval, df_eval, d2f_eval_initial);

% --- Plotting Setup ---
% Domain for iterations
x_vals = linspace(0.01, 4, 501); 
f_vals = f(x_vals);

% Domain for the global view [0.4, 4]
x_vals_global = linspace(0.4, 4, 500);
f_vals_global = f(x_vals_global);

figure('Name', 'Newton Optimization', 'Position', [100, 100, 1200, 800]);

% --- 1. Initialize Global View (Subplot 1) ---
subplot(3, 3, 1);
hold on; box on;
plot(x_vals_global, f_vals_global, '-r', 'LineWidth', 1.5);
xlabel('$x$', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('$f(x)$', 'Interpreter', 'latex', 'FontSize', 14);
title('Global View over $x \in [0.4, 4]$', 'Interpreter', 'latex', 'FontSize', 12);
set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 11, 'LineWidth', 1);
xlim([0.4, 4]); % Fix the view to the requested interval

% Plot initial guess (Iteration 0)
plot_iteration(iter, x_guess, f_eval, df_eval, d2f_eval_initial, x_vals, f_vals);

while abs(df_eval) > tol
    iter = iter + 1;
    d2f_eval_step = d2f(x_guess); % Used for calculating the Newton step
    
    % Update guess
    x_guess = x_guess - (df_eval/d2f_eval_step);
    
    % Evaluate new state
    df_eval = df(x_guess);
    f_eval = f(x_guess);
    d2f_current = d2f(x_guess); % Used to accurately print and plot the new state
    
    % Store points to map the trajectory on the global view
    x_hist(end+1) = x_guess;
    f_hist(end+1) = f_eval;
    
    fprintf('%2d | %7.4f | %9.7f | %9.4f | %9.4f \n', iter, x_guess, f_eval, df_eval, d2f_current);
    
    % Plot up to 7 subsequent iterations
    if iter <= 7
        plot_iteration(iter, x_guess, f_eval, df_eval, d2f_current, x_vals, f_vals);
    end
end

% --- 2. Overlay Convergence Trajectory on Global View ---
subplot(3, 3, 1);
plot(x_hist, f_hist, 'ko--', 'MarkerFaceColor', 'y', 'LineWidth', 1.2, 'MarkerSize', 5);
hold off;


%-------------------------------------------------------------------------%
%------------------------- PLOTTING FUNCTION -----------------------------%
%-------------------------------------------------------------------------%
function plot_iteration(iter, x_k, f_k, df_k, d2f_k, x_vals, f_vals)
    % Target subplots 2 through 9
    subplot(3, 3, iter + 2);
    hold on; box on;
    
    % Calculate Taylor approximations
    first_order = f_k + df_k .* (x_vals - x_k);
    second_order = f_k + df_k .* (x_vals - x_k) + 0.5 * d2f_k .* (x_vals - x_k).^2;
    
    % Plot lines
    p1 = plot(x_vals, f_vals, '-r', 'LineWidth', 1.5);
    p2 = plot(x_vals, first_order, ':g', 'LineWidth', 1.5);
    p3 = plot(x_vals, second_order, ':b', 'LineWidth', 1.5);
    
    % Vertical black line for the current x evaluation point
    xline(x_k, '--k', "x_i", 'LineWidth', 1);
    
    % Scientific formatting
    set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 11, 'LineWidth', 1);
    xlabel('$x$', 'Interpreter', 'latex', 'FontSize', 14);
    ylabel('$f(x)$', 'Interpreter', 'latex', 'FontSize', 14);
    title(sprintf('Iteration %d', iter), 'Interpreter', 'latex', 'FontSize', 12);
    
    % --- DYNAMIC ZOOMING LOGIC ---
    % Changed baseline from 0.00 to 0.005 to prevent over-zooming on Y-axis
    y_window = 0.005 + 0.2*abs(df_k); 
    ylim([f_k - y_window, f_k + y_window]);
    
    x_window = 0.3 + 0.5*abs(df_k);
    xlim([max(0.1, x_k - x_window), min(max(x_vals), x_k + x_window)]);
    
    % Generate legend only on the first iteration subplot
    if iter == 0
        legend([p1, p2, p3], {'original', '1st order approx.', '2nd order approx.'}, ...
            'Interpreter', 'latex', 'Location', 'northeast', 'FontSize', 10, ...
            'EdgeColor', 'k');
    end
    hold off;
end