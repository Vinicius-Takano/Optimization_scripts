%-------------------------------------------------------------------------%
%----------------------------- Método Simplex ----------------------------%  
%-------------------------------------------------------------------------%  
clear, clc

% DADOS DE ENTRADA DO PROBLEMA
c = [2 6];                                                                  % Coeficientes da função objetivo à MAXIMIZAR
A = [-1  1; 
      2  1];                                                                % Matriz de coeficientes das restrições
b = [1; 2];                                                                 % Lado direito das restrições

% MONTAGEM DA TABELA INICIAL
[m, n] = size(A);
table = [ A,  eye(m),       b; 
         -c,  zeros(1, m),  0 ];

disp('Tabela inicial:')
disp(num2str(table, '%10.2f'))

% LOOP DO SIMPLEX
iter = 0;
while any(table(end, 1:end-1) < 0)
    iter = iter + 1;
    
    [~, C] = min(table(end, 1:end-1));                                      % Encontrar a Coluna Pivô
    coluna_pivo = table(1:m, C);
    rhs = table(1:m, end);                                                  % Encontrar a Linha Pivô          
    
    razoes = inf(m, 1); 
    elementos_validos = coluna_pivo > 0; 
    razoes(elementos_validos) = rhs(elementos_validos) ./ coluna_pivo(elementos_validos);
    
    [min_razao, L] = min(razoes);
    
    if isinf(min_razao)
        disp('Problema Ilimitado. Nenhuma linha pivô válida encontrada.');
        break;
    end
    
    % Pivoteamento 
    table(L, :) = table(L, :) / table(L, C);
    for i = 1:size(table, 1)
        if i ~= L
            table(i, :) = table(i, :) - table(i, C) * table(L, :);
        end
    end
    
    fprintf('\nIteração n° %d:\n', iter);
    disp(num2str(table, '%10.2f'))
end

fprintf('\nResultado Final:\n');
disp(num2str(table, '%10.2f'))
fprintf('Valor ótimo de Z: %.2f\n', table(end, end));