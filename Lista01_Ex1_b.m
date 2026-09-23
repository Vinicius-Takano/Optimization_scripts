clear; clc; close all;

[x1, x2] = meshgrid(-2:0.05:4, -1:0.05:4);
f = x1.^2 + x1.*x2 + x2.^2;

fig = figure(Name='Lagrange', Color='w');

fontSize = 11;
fontName = 'Times New Roman';
lineWidth = 1.5;

% Curvas de Nível
ax1 = subplot(1, 2, 1);
hold on; grid on; axis equal;
set(ax1, GridAlpha=0.15, MinorGridAlpha=0.1, FontName=fontName, FontSize=fontSize);
box on;

[C, h] = contour(x1, x2, f, 20, 'LineWidth', 1.0);
colormap(ax1, parula); 

cb = colorbar;
cb.Label.String = '$f(x_1, x_2)$';
cb.Label.Interpreter = 'latex';
cb.Label.FontSize = fontSize;

% restrição
x1_rest = -2:0.1:4;
x2_rest = (3 - x1_rest) / 2;
plot(x1_rest, x2_rest, 'k--', LineWidth=lineWidth);

plot(0, 1.5, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6); % Ponto extremo

xlabel('$x_1$', Interpreter='latex', FontSize=fontSize + 2);
ylabel('$x_2$', Interpreter='latex', FontSize=fontSize + 2);
title('(a) Curvas de Nível e Restrição', FontWeight='bold', FontSize=fontSize + 2);
legend('Contornos de f', 'Restrição: x_1 + 2x_2 = 3', 'Mínimo (0, 1.5)', Location='northeast', FontSize=fontSize);
hold off;


% Gráfico 3D
ax2 = subplot(1, 2, 2);
hold on; grid on;
set(ax2, GridAlpha=0.15, MinorGridAlpha=0.1, FontName=fontName, FontSize=fontSize);
box on;

s = surfc(x1, x2, f, EdgeColor='none', FaceAlpha=0.8); % s(1) é a superfície, s(2) é o contorno.

s(2).LineWidth = 0.5;
colormap(ax2, parula);

% restrição
f_rest = x1_rest.^2 + x1_rest.*x2_rest + x2_rest.^2;
plot3(x1_rest, x2_rest, f_rest, 'k--', LineWidth=2); 

plot3(0, 1.5, 2.25, 'ro', MarkerFaceColor='r', MarkerSize=7);
view(-35, 25); 
zlim([-2, max(f(:))]); 

z_min = ax2.ZLim(1); 
plot3(x1_rest, x2_rest, z_min * ones(size(x1_rest)), 'k-', 'LineWidth', 1);


xlabel('$x_1$', 'Interpreter', 'latex', 'FontSize', fontSize + 2);
ylabel('$x_2$', 'Interpreter', 'latex', 'FontSize', fontSize + 2);
zlabel('$f(x_1, x_2)$', 'Interpreter', 'latex', 'FontSize', fontSize + 2);
title('(b) Superf\''icie e Interse\c{c}\~ao', 'Interpreter', 'latex', 'FontWeight', 'bold', 'FontSize', fontSize + 2);
hold off;

