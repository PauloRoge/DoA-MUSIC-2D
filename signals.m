function [Y, Z] = signals(M, snapshots, delta, lambda, AoA, ...
    source, d, pathloss_exp, transmittedpower, noisepowerdBm)
    noisepower = 10^((noisepowerdBm - 30) / 10);

    % initialize channel matrix and pathloss
    H = zeros(M, source);
    beta = zeros(source, 1);

    % compute channel matrix with near-field steering vector
    for s = 1:source
        beta(s) = sqrt(lambda^pathloss_exp / ...
            ((4 * pi * d(s))^pathloss_exp)); 

        A = responsearray(M, delta, lambda, AoA(s), d(s)); 
        H(:, s) = beta(s) * A;
    end

    X = sqrt(transmittedpower) * randn(source, snapshots) / ...
    sqrt(2); % transmitted signals

    Z = sqrt(noisepower) * (randn(M, snapshots) + ...
        1j * randn(M, snapshots)) / sqrt(2); % AWGN noise

    Y = H * X + Z; % received signal matrix

    % compute and display SNR
    SNR = 10 * log10(sum(abs(Y).^2, 'all') / ...
        sum(abs(Z).^2, 'all'));
    
    disp(['SNR = ', num2str(SNR), ' dB']);
end
