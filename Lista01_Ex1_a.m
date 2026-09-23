clear; clc; close all;

P1 = [1, 0, 2]; % Coordenadas de P1                                              
P_min = [7/6, 1/3, 13/6]; % Ponto de menor distância calculado

% Plano x +2y + z = 4
[X, Y] = meshgrid(linspace(0, 2.5, 40), linspace(-1, 1.5, 40));
Z = 4 - X - 2.*Y;

fig = figure(Color='w');
hold on; grid on; box on;
h_plane = surf(X, Y, Z, FaceColor='interp', EdgeColor='interp', FaceAlpha=0.8);

h_line = plot3([P1(1), P_min(1)], [P1(2), P_min(2)], [P1(3), P_min(3)], 'k--', LineWidth=1); % Linha de menor distância.

h_P1 = plot3(P1(1), P1(2), P1(3), 'ro', MarkerSize=8, MarkerFaceColor='r'); % Ponto P1
h_Pmin = plot3(P_min(1), P_min(2), P_min(3), 'o', MarkerSize=8, MarkerFaceColor='b'); % Ponto mínimo no plano

% Eixos e títulos
set(gca, FontSize=12, FontName='Times New Roman', LineWidth=1);
xlabel('$x$', Interpreter='latex', FontSize=16);
ylabel('$y$', Interpreter='latex', FontSize=16);
zlabel('$z$', Interpreter='latex', FontSize=16);
%title('Otimização da Distância Ponto-Plano', Interpreter='latex', FontSize=16);

leg = legend([h_plane, h_P1, h_Pmin, h_line], ...
       {'Plano restri\c{c}\~ao: $x + 2y + z = 4$', ...
        'Ponto de origem: $P_1(1, 0, 2)$', ...
        "Ponto de m\'inimo: $P_{min}(\frac{7}{6}, \frac{1}{3}, \frac{13}{6})$", ...
        'Menor dist\^ancia: $d = \frac{\sqrt{6}}{6}$'}, ...
       Interpreter='latex', Location='northeast', FontSize=12);
view(35, 25);  
axis equal;    
zlim([1, 3]); 
hold off;