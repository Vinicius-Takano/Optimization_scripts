clear; clc; close all;
% Considerando x = x1, y = x2 e z = F
Fmax = [1/3, 4/3, 26/3]; % Coordenadas do ponto ótimo

% Função Objetivo (z = 2x1 + 6x2)
[X, Y] = meshgrid(linspace(0, 2, 40), linspace(0, 2, 40));
Z = 2.*X + 6.*Y;

fig = figure(Color='w');
hold on; grid on; box on;

h_plane = surf(X, Y, Z, FaceColor='interp', EdgeColor='none', FaceAlpha=0.5);

x_poly = [0, 1, 1/3, 0]; % Coordenadas x dos vértices (A, C, D, B)
y_poly = [0, 0, 4/3, 1]; % Coordenadas y dos vértices
h_region = patch(x_poly, y_poly, zeros(1,4), 'g', FaceAlpha=0.3);


x_line = linspace(0, 2, 100);
y_r1 = x_line + 1;      % Restrição 1: -x1 + x2 = 1  
y_r2 = -2.*x_line + 2;  % Restrição 2: 2x1 + x2 = 2
h_r1 = plot3(x_line, y_r1, zeros(1,100), 'b-', LineWidth=2);
h_r2 = plot3(x_line, y_r2, zeros(1,100), 'm-', LineWidth=2);

h_F_max = plot3(Fmax(1), Fmax(2), Fmax(3), 'ro', MarkerSize=8, MarkerFaceColor='r');
plot3([Fmax(1) Fmax(1)], [Fmax(2) Fmax(2)], [0 Fmax(3)], 'k--', LineWidth=1.5);



set(gca, FontSize=12, FontName='Times New Roman', LineWidth=1);
xlabel('$x_1$', Interpreter='latex', FontSize=16);
ylabel('$x_2$', Interpreter='latex', FontSize=16);
zlabel('$F$', Interpreter='latex', FontSize=16);

xlim([0, 1.5]);
ylim([0, 2]);
zlim([0, 10]);
view(-35, 25); 

legend([h_plane, h_region, h_r1, h_r2, h_F_max], ...
    {'Fun\c{c}\~ao Objetivo: $F = 2x_1 + 6x_2$', ...
    'Regi\~ao Viavel', ...
    'Restri\c{c}\~ao 1: $-x_1 + x_2 \leq 1$', ...
    'Restri\c{c}\~ao 2: $2x_1 + x_2 \leq 2$', ...
    'Ponto Otimo: $(\frac{1}{3}, \frac{4}{3}, \frac{26}{3})$'}, ...
    Interpreter='latex', Location='northwest', FontSize=10);
    
hold off;