%-------------------------------------------------------------------------%
%----------------------------- FIBONACCI METHOD --------------------------%
%-------------------------------------------------------------------------%
clear; clc; close all;
%f_obj = @(x) 0.65 - 0.75./(1+x.^2) - 0.65.*x.*atan(1./x);
f_obj = @(x) -1./((x-1).^2).*(log(x) - 2.*(x-1)./(x+1));   
%f_obj = @(x) 2*x - 16*cos(x);
%f_obj = @(x) 2.*x.^2 + 2./x;
%f_obj = @(x) x.^2 - 10.*x + 21; 
% Inputs
N = 6;
A1 = 1.5;
B1 = 4;
L0 = B1 - A1;
x_plot = A1:0.01:B1;
f_plot = f_obj(x_plot);
% Sequência de Fibonacci
Fib = [1 1];
for i = 3:(N+1)
    Fib(i) = Fib(i-1) + Fib(i-2);
end
L2_star = (Fib(N-1)/Fib(N+1)) * (B1-A1);
J = 2;
figure(Name='Evolução - Método de Fibonacci');
plot_idx = 1;
fprintf('===================================================================================================\n');
fprintf(' J |     [A1, B1]     |   L1   | L2_star |   x1   |   x2   |    f1    |    f2    | Condição \n');
fprintf('---------------------------------------------------------------------------------------------------\n');
% Fluxograma
while true
    L1 = B1 - A1;
    
    if L2_star > (L1 / 2)
        x1 = B1 - L2_star;
        x2 = A1 + L2_star;
    else
        x1 = A1 + L2_star;
        x2 = B1 - L2_star;
    end
    if J == N
        epsilon = 1e-5; % Small perturbation to separate the points
        x2 = x1 + epsilon;
    end
    
    f1 = f_obj(x1);
    f2 = f_obj(x2);
    
    if f1 > f2
        cond_str = 'f1 > f2';
    elseif f2 > f1
        cond_str = 'f2 > f1';
    else
        cond_str = 'f1 == f2';
    end
    
    % Parametros da iteração atual
    fprintf('%2d | [%.4f, %.4f] | %.4f | %7.4f | %.4f | %.4f | %8.7f | %8.7f | %s \n', ...
            J, A1, B1, L1, L2_star, x1, x2, f1, f2, cond_str);
            
    % Plot atual
    subplot(2, 3, plot_idx)
    h_f = plot(x_plot, f_plot, 'k', 'LineWidth', 1); hold on;
    h_A1 = xline(A1, '-r', 'LineWidth', 1.5); 
    xline(B1, '-r', 'LineWidth', 1.5); % Sem rótulo e sem salvar handle pois tem a mesma cor de A1
    h_x1 = xline(x1, '--b'); 
    h_x2 = xline(x2, '--m');
    title(sprintf('Iteracao J = %d', J)); 
    
    legend([h_f, h_A1, h_x1, h_x2], {'f(x)', 'A_1, B_1', 'x_1', 'x_2'}, 'Location', 'best', 'FontSize', 8);
    
    hold off;
    plot_idx = plot_idx + 1;
    % ----------------------------
    
    if f1 > f2
        A1 = x1;
        L2_star = (Fib(N-J+1)*L1)/Fib(N-J+3);
    elseif f2 > f1
        B1 = x2;
        L2_star = (Fib(N-J+1)*L1)/Fib(N-J+3);
    else
        A1 = x1;
        B1 = x2;
        L2_star = (Fib(N-J+1)*(B1-A1))/Fib(N-J+3);
    end
    
    J = J + 1;
    if J == N+1
        break;
    end
end
fprintf('===================================================================================================\n');
L_N = B1 - A1;

if f1 < f2
    x_min = x1;
    f_min = f1;
else
    x_min = x2;
    f_min = f2;
end

fprintf('\n--- Fim do Algoritmo ---\n');
fprintf('Mínimo contido no intervalo final: A1 = %.4f, B1 = %.4f\n', A1, B1);
fprintf('Comprimento da Incerteza (L_N) = %.4f\n', L_N);
fprintf('Erro relativo (L/L0) = %.4f\n', L_N/L0);
fprintf('Ponto de mínimo (x_min) = %.7f\n', x_min);
fprintf('Valor mínimo obtido f(x_min) = %.7f\n', f_min);