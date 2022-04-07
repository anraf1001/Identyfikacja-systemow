close all; clear; clc;

%% Wyświetlenie danych pomiarowych
load IdentWsadowaDyn.mat

Tp = 0.01;
n = 1:length(DaneDynW);
uW = DaneDynW(n, 1);
yW = DaneDynW(n, 2);
uC = DaneDynC(n, 1);
yC = DaneDynC(n, 2);
N = length(uW);
t = (0:N-1) * Tp;

figure
subplot(2, 2, 1)
plot(t, uW)
title('u - szum biały')
subplot(2, 2, 2)
plot(t, uC)
title('u - szum kolorowy')
subplot(2, 2, 3)
plot(t, yW)
title('y - szum biały')
subplot(2, 2, 4)
plot(t, yC)
title('y - szum kolorowy')

%% Podział danych pomiarowych na 2 podzbiory
uW_est = uW(1:fix(N/2));
uW_wer = uW(fix(N/2)+1:end);

yW_est = yW(1:fix(N/2));
yW_wer = yW(fix(N/2)+1:end);

uC_est = uC(1:fix(N/2));
uC_wer = uC(fix(N/2)+1:end);

yC_est = yC(1:fix(N/2));
yC_wer = yC(fix(N/2)+1:end);

N_est = length(uW_est);
N_wer = length(uW_wer);
d = 2;

%% Identyfikacja - szum biały
% phiT(n) = [y(n-1) u(n-1)]
PhiW = zeros(N_est, d);
for k=2:N_est
    PhiW(k, :) = [yW_est(k-1), uW_est(k-1)];
end

pLSW = pinv(PhiW) * yW_est;
TW = -Tp / log(pLSW(1));
kW = pLSW(2) / (1 - pLSW(1));

%% Identyfikacja - szum kolorowy
% phiT(n) = [y(n-1) u(n-1)]
PhiC = zeros(N_est, d);
for k=2:N_est
    PhiC(k, :) = [yC_est(k-1), uC_est(k-1)];
end

pLSC = pinv(PhiC) * yC_est;
TC = -Tp / log(pLSC(1));
kC = pLSC(2) / (1 - pLSC(1));

%% Wykresy - szum biały
t_wer = (0:N_wer-1)*Tp;
G0 = tf(2.0, [0.5, 1]);

GW = tf(kW, [TW, 1]);
y0W = lsim(G0, uW_wer, t_wer);
yW_hat = zeros(N_wer, 1);
for k=2:N_wer
    yW_hat(k) = pLSW(1) * yW_wer(k-1) + pLSW(2) * uW_wer(k-1);
end
ymW = lsim(GW, uW_wer, t_wer);

figure
plot(t_wer, yW_wer)
hold on
plot(t_wer, y0W)
plot(t_wer, yW_hat)
plot(t_wer, ymW)
legend('zmierzona odpowiedź y(n)', 'odpowiedź niezakłócona systemu y_0(n)', 'odpowiedź predyktora jednokrokowego y(n|n-1)', 'odpowiedź modelu symulowanego y_m(n)')
title('Szum biały')
grid on

%% Wykresy - szum kolorowy
GC = tf(kC, [TC, 1]);
y0C = lsim(G0, uC_wer, t_wer);
yC_hat = zeros(N_wer, 1);
for k=2:N_wer
    yC_hat(k) = pLSC(1) * yC_wer(k-1) + pLSC(2) * uC_wer(k-1);
end
ymC = lsim(GC, uC_wer, t_wer);

figure
plot(t_wer, yC_wer)
hold on
plot(t_wer, y0C)
plot(t_wer, yC_hat)
plot(t_wer, ymC)
legend('zmierzona odpowiedź y(n)', 'odpowiedź niezakłócona systemu y_0(n)', 'odpowiedź predyktora jednokrokowego y(n|n-1)', 'odpowiedź modelu symulowanego y_m(n)')
title('Szum kolorowy')
grid on
