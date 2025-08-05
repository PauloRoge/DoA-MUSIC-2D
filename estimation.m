function AIC = estimation(M, eigenvalues_sorted, snapshots)
    aic_values = zeros(1, M-1); % vetor para armazenar os valores do AIC
    psi = 1; % fator de penalizacao ajustavel

    for p = 0:M-1
        if p < M
            
            noise = mean(eigenvalues_sorted(p+1:end)); % ruído
            % soma do log dos menores autovalores
            log_term = -snapshots * (sum(log(eigenvalues_sorted(p+1:end))) - (M-p) * log(noise));
            penalty_term = psi * p * (2 * M - p); % penalização ajustada
            aic_values(p+1) = log_term + penalty_term; % cálculo do AIC
        end
    end

    AIC = aic_values;
end