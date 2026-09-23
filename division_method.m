%-------------------------------------------------------------------------%
%-----------------------MÉTODO DA DIVISÃO PELA METADE---------------------%
%-------------------------------------------------------------------------%
clear, clc, clear tables                                                    % Função objetivo
f_obj = @(x) -1./((x-1).^2).*(log(x) - 2.*(x-1)./(x+1));                   % Equação (3)
%f_obj = @(x) 2*x - 16*cos(x);                                               % Equação (4)
%f_obj = @(x) 2.*x.^2 + 2./x;                                               % Equação (5)
%f_obj = @(x) x.*(x-1.5);                                                   % slide yohan

% Valores iniciais
a = 1.5;
b = 4; 
L0 = b-a;
x0 = (a+b)/2;
x1 = (a+x0)/2;
x2 = (x0+b)/2;
error_tol = 2/21;
iter = 0; 
x_plot = a:0.01:b;
f_plot = f_obj(x_plot);

figure(Name='Evolução das Iterações');
% First Plot
subplot(2, 3, 1) % Grade 2x3
h_f = plot(x_plot, f_plot, 'k', 'LineWidth', 1);
hold on
h_ab = xline(a, '-r');
xline(b, '-r');  
h_x12 = xline(x1, '--g'); 
h_x0 = xline(x0, '--b');
xline(x2, '--g');
title(sprintf('Iteracao %d (Inicial)', iter))
legend([h_f, h_ab, h_x0, h_x12], {'f(x)', 'a, b', 'x_0', 'x_1, x_2'}, 'Location', 'best', 'FontSize', 8)
hold off

fa = f_obj(a);
fb = f_obj(b);
f0 = f_obj(x0);
f1 = f_obj(x1);
f2 = f_obj(x2);

% Iteracao Inicial
fprintf('--- Iteracao %d (Inicial) ---\n', iter);
cabecalho = {'-','a', 'x1', 'x0', 'x2', 'b'};
tabela_valores = ["L:", a, x1, x0, x2, b];
tabela_f = ["F:", fa, f1, f0, f2, fb];
disp(cabecalho)
disp(tabela_valores)
disp(tabela_f)

fprintf('-> Intervalo de Incerteza: [%.4f, %.4f]\n', a, b);
fprintf('-> Erro Relativo: %.4f\n', (b-a)/L0);
fprintf('-> Mínimo obtido: %.7f\n', x0);

while (b-a)/L0 >= error_tol
    iter = iter + 1;
  
    if (f2 > f0) && (f0 > f1)
        criterio = 'f2 > f0 e f0 > f1 -> O mínimo está à esquerda (novo intervalo: [a, x0])';
        b = x0;
        x0 = x1;
        a = x0 - (b - x0);
    elseif (f2 < f0) && (f0 < f1)
        criterio = 'f2 < f0 e f0 < f1 -> O mínimo está à direita (novo intervalo: [x0, b])';
        a = x0;
        x0 = x2;
        b = x0 + (x0 - a);
    elseif (f1 >= f0) && (f2 >= f0)
        criterio = 'f1 > f0 e f2 > f0 -> O mínimo é central (novo intervalo: [x1, x2])';
        a = x1;
        b = x2;
        x0 = (x1 + x2) / 2;
    else
        break
    end
    
    x1 = (a + x0) / 2;
    x2 = (x0 + b) / 2;
    fa = f_obj(a);
    fb = f_obj(b);
    f0 = f_obj(x0);
    f1 = f_obj(x1);
    f2 = f_obj(x2);
    
    fprintf('\n--- Iteracao %d ---\n', iter);
    fprintf('Critério utilizado: %s\n', criterio);
    
    tabela_valores = ["L:", a, x1, x0, x2, b];
    tabela_f = ["F:", fa, f1, f0, f2, fb];
    disp(tabela_valores)
    disp(tabela_f)
    
    % EXIBIÇÃO: Intervalo de incerteza e erro da iteração atual
    fprintf('-> Intervalo de Incerteza: [%.4f, %.4f]\n', a, b);
    fprintf('-> Erro Relativo: %.4f\n', (b-a)/L0);
    fprintf('-> Mínimo obtido: %.7f\n', x0);
    
    % Plotting
    subplot(2, 3, iter + 1) 
    h_f = plot(x_plot, f_plot, 'k', 'LineWidth', 1);
    hold on
    h_ab = xline(a, '-r');
    xline(b, '-r');
    h_x12 = xline(x1, '--g');
    h_x0 = xline(x0, '--b');
    xline(x2, '--g');
    title(sprintf('Iteracao %d', iter))
    legend([h_f, h_ab, h_x0, h_x12], {'f(x)', 'a, b', 'x_0', 'x_1, x_2'}, 'Location', 'best', 'FontSize', 8)
    hold off
end

fprintf('\n======================================================\n');
fprintf('                     RESULTADO FINAL                    \n');
fprintf('======================================================\n');
fprintf('Iterações totais: %d\n', iter);
fprintf('Intervalo de Incerteza: [%.4f, %.4f]\n', a, b);
fprintf('Tamanho do Intervalo (L): %.4f\n', b-a);
fprintf('Erro Relativo: %.4f\n', (b-a)/L0);
fprintf('Ponto de mínimo estimado (x0): %.7f\n', x0);
fprintf('Função no mínimo estimado (f(x0)): %.7f\n', f_obj(x0));
fprintf('======================================================\n');