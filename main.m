%============================================================
% Paulo R. A. Candido Jr.
% classical-music-near-field-doa
%============================================================
close all; clear; clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
architecture = 32;                 % antennas
frequency = 3e9;                   % 3 GHz
lambda = (3e8) / frequency;        % wave-length
delta = lambda/2;                  % antenna spacing
snapshots = 100;                   % number of samples
power = 0.1;                       % transmission power (w)
noisepowerdBm = -50;               % noise power in dBm
AoA = [-53 -12 48 55];             % aoa (degrees)
d = [4 10 6 12];                   % relative distances (m)
source = length(AoA);              % number of sources
alpha = 2;                         % pathloss exponent
theta = -90:1:90;                  % angle range
d_range = linspace(3, 15, 200);    % range

% fonte do plot
set(groot,'defaultAxesTickLabelInterpreter','latex');

figure;
hold on; box on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate Pseudospectrum 2D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ii = 1:length(architecture)
    M = architecture(ii);
    Y = signals(M, snapshots, delta, lambda, AoA, source, ...
        d, alpha, power, noisepowerdBm);

    Pmusic = music(Y, M, theta, d_range, snapshots, delta, ...
        lambda);
    
    % Plot do pseudoespectro MUSIC
    surf(theta, d_range, 10 * log10(Pmusic.'), ...
        'EdgeColor', 'none');
    
    colormap parula;
    shading interp;
    view(0,90);
    axis tight;
    set(gca, 'fontsize', 14);
    xlabel('Angle (degrees)', 'FontSize', 12);
    ylabel('Distance (m)', 'FontSize', 12);
    hBar = colorbar;
    clim([min(10 * log10(Pmusic(:))), ...
        max(10 * log10(Pmusic(:)))]);

    z_offset = max(10 * log10(Pmusic(:))) + 1;
    plot3(AoA, d, z_offset * ones(size(AoA)), 'ko', ...
        'MarkerSize', 4, 'LineWidth', 1);
    hold off;

end

hold off;