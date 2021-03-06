%% Read all the files
close all;
clear;
clc;

%% Reading the details from the files generated from C++ code
details = fopen('details.txt','r');
parameters = textscan(details, '%d,%d,%f,%f,%f,%f,%f,%f,%d,%f,%d');
nx = cell2mat(parameters(1));           % Number of nodes in x-dir
ny = cell2mat(parameters(2));           % Number of nodes in y-dir
n = cell2mat(parameters(9));            % Number of time steps including t = 0
dt = cell2mat(parameters(10));          % Time Step length
xlim1 = cell2mat(parameters(5));        % Lower limit of the grid in x-direction
xlim2 = cell2mat(parameters(6));        % Upper limit of the grid in x-direction
ylim1 = cell2mat(parameters(7));        % Lower limit of the grid in y-direction
ylim2 = cell2mat(parameters(8));        % Upper limit of the grid in y-direction
printstep = cell2mat(parameters(11));   % Frequency of storing the images (every nth time step)

x = linspace(xlim1, xlim2, nx);         % X-axis Array
y = linspace(ylim1, ylim2, ny);         % Y-axis Array
dy = y(2)-y(1);                         % Grid size in y-direction
dx = x(2)-x(1);                         % Grid size in x-direction
[xx, yy] = meshgrid(x, y);              % Making the grid
n = n/printstep + 1;                    % Number of stored time steps

%% Reading the grid details from files in the master variables

masterphi = double(zeros(ny, nx, n));
masterpsix = double(zeros(ny, nx, n));
masterpsiy = double(zeros(ny, nx, n));
masterpsixy = double(zeros(ny, nx, n));
u = double(zeros(ny, nx, n));
v = double(zeros(ny, nx, n));

phi = fopen('phi.txt','r');
psix = fopen('psix.txt','r');
psiy = fopen('psiy.txt','r');
psixy = fopen('psixy.txt','r');
uu = fopen('Velocity_x.txt','r');
vv = fopen('Velocity_y.txt','r');

for i = 1:n
    for j = 1:ny
        A = textscan(phi, '%f', nx, 'Delimiter', ',');
        masterphi(j, :, i) = (cell2mat(A))';
        A = textscan(psix, '%f', nx, 'Delimiter', ',');
        masterpsix(j, :, i) = (cell2mat(A))';
        A = textscan(psiy, '%f', nx, 'Delimiter', ',');
        masterpsiy(j, :, i) = (cell2mat(A))';
        A = textscan(psixy, '%f', nx, 'Delimiter', ',');
        masterpsixy(j, :, i) = (cell2mat(A))';
        A = textscan(uu, '%f', nx, 'Delimiter', ',');
        u(j, :, i) = (cell2mat(A))';
        A = textscan(vv, '%f', nx, 'Delimiter', ',');
        v(j, :, i) = (cell2mat(A))';
    end
end

%% Plotting the stored data
tagMain = 'Rayleigh/';
tagSize = 'n16x16/';
pause on;
for i = 1:n
    
    if(i == 1)
        figure1 = figure;
        axes1 = axes('Parent',figure1,'FontSize',24);
    end
    
    quiver(xx(:,2:end),yy(:,2:end),u(:,2:end,1),v(:,2:end,1),'Parent',axes1);
    axis([xlim1 xlim2 ylim1 ylim2]);
    hold on
    
    contour(x, y, masterphi(:, :, 1),[0 0]);
    
    %     surfc(x, y, masterphi(:, :, i));
    
    [c,h] = contour(x, y, masterphi(:, :, i),[0 0]);
    set(h, 'LineWidth', 2.0, 'LineColor', 'k');
    xlabel('X','FontSize',24);
    ylabel('Y','FontSize',24);
    check = double(i-1) * dt * double(printstep);
    str = sprintf('Contour at t = %.6f', check);
    title(str,'FontSize',24);
    axis square
    pause(0.1);
    hold off
    
    %     if(rem(i-1,8)==0)
    %         fname = sprintf([tagMain  tagSize  'T2_%d'],(i-1));
    %         print('-depsc2','-r600',fname);
    %     end
end
% error = abs(masterphi(:,:,end)) - abs(masterphi(:,:,1);
% surf(x,y,error)
% load('Convergence.mat')
% e(4) = max(max(abs(abs(masterphi(:,:,end)) - abs(masterphi(:,:,1)))));
% edx(4) = dx;
% save('Convergence.mat','e','edx');
% close all;
