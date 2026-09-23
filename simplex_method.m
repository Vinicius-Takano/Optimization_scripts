%-------------------------------------------------------------------------%
%----------------------------- Método Simplex ----------------------------%  
%-------------------------------------------------------------------------%  
clear, clc

% Objetive function
J = [2 6];                                                                  % Vetor função objetivo (Máximizar)
j = -J;                                                                     % Minimizar a função

% Restrictions
Mb = [-1 1; 
       2 1];

b = [1; 2; 0];
Ma = eye(length(b));

% Matriz 
table = [[Mb; j], Ma, b, zeros(length(b),1)];
disp('Tabela inicial')
disp(table)

while min(table(end,:)) < 0
    % Find the pivot column "C" 
    [M, C] = min(table(end,:));
    table_i = table;
    
    ratios = table_i(:,end-1) ./ table(:,C);
    ratios(table(:,C) <= 0) = Inf;
    ratios(end) = Inf; 
    table_i(:,end) = ratios;
    
    % Find the pivot row
    [N, L] = min(table_i(:,end));
    
    if isinf(N)
        disp('The problem is unbounded. No valid pivot element found.');
        break;
    end
    
    if table_i(L,C) ~= 1
        table_i(L, :) = table_i(L, :)/table_i(L,C);
    end
    
    for i=1:length(table_i(:,C))
        if i ~= L && table_i(i,C) ~= 0
            table_i(i,:) = (-1)*(table_i(i,C))*table_i(L,:)+table_i(i,:);
        end
    end
    table = table_i;
    disp(table)
end

disp("Resultado:")
disp(table)