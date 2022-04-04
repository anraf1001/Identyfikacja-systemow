close all; clear; clc;

%% Wyświetlenie danych pomiarowych
load IdentWsadowaStat.mat

n = 1:length(DaneStatW);
uW = DaneStatW(n, 1);
yW = DaneStatW(n, 2);
uC = DaneStatC(n, 1);
yC = DaneStatC(n, 2);
N = length(uW);

figure
subplot(2, 1, 1)
plot(uW, yW)
subplot(2, 1, 2)
plot(uC, yC)

%% Wyznaczenie regresora - szum biały
phi = zeros(4, N);
phi(1, :) = ones(1, N);
phi(2, :) = 1 ./ uW;
phi(3, :) = 1 ./ (uW .^ 2);
phi(4, :) = 1 ./ (uW .^ 3);

Phi = phi';

pLS = pinv(Phi) * yW;
yLS = pLS(1) + pLS(2) ./ uW + pLS(3) ./ (uW .^ 2) + pLS(4) ./ (uW .^ 3);

figure;
hold on
plot(uW, yW)
plot(uW, yLS, 'LineWidth', 3)
title('Szum biały')

%% Wyznaczenie regresora - szum kolorowy
phi = zeros(4, N);
phi(1, :) = ones(1, N);
phi(2, :) = 1 ./ uC;
phi(3, :) = 1 ./ (uC .^ 2);
phi(4, :) = 1 ./ (uC .^ 3);

Phi = phi';

pCLS = pinv(Phi) * yC;
yCLS = pCLS(1) + pCLS(2) ./ uC + pCLS(3) ./ (uC .^ 2) + pCLS(4) ./ (uC .^ 3);

figure;
hold on
plot(uC, yC)
plot(uC, yCLS, 'LineWidth', 3)
title('Szum kolorowy')

%% Macierz kowariancji
sig2 = 1 / (N - 4) * sum(yW - Phi * pLS);
Cov = sig2 * inv(phi * Phi);

PU95_1_min = pLS(1) - 1.96 * sqrt(Cov(1, 1));
PU95_1_max = pLS(1) + 1.96 * sqrt(Cov(1, 1));

PU95_2_min = pLS(2) - 1.96 * sqrt(Cov(2, 2));
PU95_2_max = pLS(2) + 1.96 * sqrt(Cov(2, 2));

PU95_3_min = pLS(3) - 1.96 * sqrt(Cov(3, 3));
PU95_3_max = pLS(3) + 1.96 * sqrt(Cov(3, 3));

PU95_4_min = pLS(4) - 1.96 * sqrt(Cov(4, 4));
PU95_4_max = pLS(4) + 1.96 * sqrt(Cov(4, 4));
