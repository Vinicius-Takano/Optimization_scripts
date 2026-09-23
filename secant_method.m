%-------------------------------------------------------------------------%
%-------------------------- MÉTODO DA SECANTE ----------------------------%
%-------------------------------------------------------------------------%
clear, clc, close all
syms x
%f_sym = 0.65 - 0.75/(1+x^2) - 0.65*x*atan(1/x);
f_sym = -(1 / (x - 1)^2) * (log(x) - 2 * (x - 1) / (x + 1));
df_sym = diff(f_sym);
f = matlabFunction(f_sym, 'Vars', x);
df = matlabFunction(df_sym, 'Vars', x);

figure('Name', 'Evolução das Iterações', 'Position', [100, 100, 1400, 800]);

x_plot = 0.01:0.01:4;
f_plot = f(x_plot);
df_plot = df(x_plot);

subplot(2, 3, 1) 
plot(x_plot, f_plot, 'k', 'LineWidth', 1.5);
hold on; grid on;
title('Função Objetivo f(x) e Convergência');
xlabel('x'); ylabel('f(x)');

% Valores iniciais
x1 = 0.5;
epson = 0.001;
t_0 = 0.01;
iter = 0;

A = x1;
df_A = df(A); 
if df_A > 0
    fprintf("Primeira derivada em A deve ser negativa\n");
    return
end

while df(t_0) < 0
    A = t_0;
    df_A = df(A);
    t_0 = 2 * t_0;
end
B = t_0;
df_B = df(B);

% Cabeçalho do console atualizado com parâmetros completos
fprintf('======================================================================================\n');
fprintf(" i |    A    |    B    |   f'(A)    |   f'(B)    |  x_{i+1}   | f'(x_{i+1}) |  f(x_{i+1})  \n");
fprintf('--------------------------------------------------------------------------------------\n');
% Na iteração 0, o x_{i+1} ainda não foi calculado
fprintf('%2d | %7.4f | %7.4f | %10.4f | %10.4f | ---------- | ----------- | ------------ \n', iter, A, B, df_A, df_B);

% Loop da Secante
for iter = 1:1:100
    
    plot_A = A;
    plot_df_A = df_A;
    plot_B = B;
    plot_df_B = df_B;
    
    x_new = A - (df_A * (B - A)) / (df_B - df_A);
    df_x_new = df(x_new);
    f_x_new = f(x_new);
   
    % Print atualizado incluindo f'(A), f'(B), x_new (como x_{i+1}) e f_x_new
    fprintf('%2d | %7.4f | %7.4f | %10.4f | %10.4f | %10.4f | %11.4f | %12.6f \n', iter, A, B, df_A, df_B, x_new, df_x_new, f_x_new);
    
    % --- ATUALIZAÇÃO DO PLOT 1 (CONVERGÊNCIA) ---
    subplot(2, 3, 1);
    plot(x_new, f(x_new), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 5, 'HandleVisibility', 'off');
    text(x_new, f(x_new), sprintf(' %d', iter), 'FontSize', 9, 'VerticalAlignment', 'bottom', 'Color', 'r');
    
    % --- PLOTAGEM DAS ITERAÇÕES COM ZOOM E SHADING ---
    if iter <= 5
        subplot(2, 3, iter + 1);
        
        % Plot da curva da derivada
        plot(x_plot, df_plot, 'k', 'LineWidth', 1.2, 'DisplayName', 'Função'); 
        hold on; grid on;
        yline(0, 'k-', 'HandleVisibility', 'off'); 
        
        % Definição do Zoom Dinâmico
        margem_x = (plot_B - plot_A) * 0.2; % Margem de 40% da largura do bracket
        limite_x = [plot_A - margem_x, plot_B + margem_x];
        xlim(limite_x);
        
        y_min = min([0, plot_df_A, plot_df_B, df_x_new]);
        y_max = max([0, plot_df_A, plot_df_B, df_x_new]);
        margem_y = (y_max - y_min) * 0.2+ 0.005;
        limite_y = [y_min - margem_y, y_max + margem_y];
        ylim(limite_y);
        
        % Sombreado do Bracket (Região de Busca Atual)
        patch([plot_A plot_B plot_B plot_A], [limite_y(1) limite_y(1) limite_y(2) limite_y(2)], ...
              'y', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'DisplayName', 'Região de Busca');
        
        % Linhas e Pontos
        plot([plot_A, plot_A], [0, plot_df_A], 'r:', 'HandleVisibility', 'off');
        plot([plot_B, plot_B], [0, plot_df_B], 'g:', 'HandleVisibility', 'off');
        plot([plot_A, plot_B], [plot_df_A, plot_df_B], 'b--', 'LineWidth', 1.5, 'DisplayName', 'Secante');
        
        plot(plot_A, plot_df_A, 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'A');
        plot(plot_B, plot_df_B, 'go', 'MarkerFaceColor', 'g', 'DisplayName', 'B');
        
        % Novo ponto x_new e sua projeção
        plot(x_new, 0, 'bx', 'MarkerSize', 8, 'LineWidth', 2, 'DisplayName', 'x_{i+1}');
        plot([x_new, x_new], [0, df_x_new], 'b:', 'HandleVisibility', 'off');
        plot(x_new, df_x_new, 'bo', 'MarkerFaceColor', 'b', 'HandleVisibility', 'off');
        
        % Textos explicativos próximos aos pontos
        text(plot_A, plot_df_A, ' A', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontWeight', 'bold');
        text(plot_B, plot_df_B, ' B', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'FontWeight', 'bold');
        text(x_new, 0, ' x_{i+1}', 'VerticalAlignment', 'top', 'Color', 'b', 'FontWeight', 'bold');
        
        title(sprintf('Iteração %d', iter));
        xlabel('x'); ylabel("f'(x)");
        legend('Location', 'best');
        hold off;
    end
    
    % Critérios
    if abs(df_x_new) <= epson
        break;
    elseif df_x_new > 0
        B = x_new;
        df_B = df_x_new; 
    elseif df_x_new < 0
        A = x_new;
        df_A = df_x_new;
    end
end