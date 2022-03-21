close all; clear; clc;

%% Parametry i uruchomienie symulacji
Tp = 0.5;
N = 1001;
tend = N * Tp;
sigma2v = 0.001;
t = (0:N) * Tp;

sim('AWident')

%% Wykresy danych pomiarowych
figure
subplot(2, 1, 1)
plot(t, Zdata(:, 1))
title('u(nTp)')
xlabel('t [s]')

subplot(2, 1, 2)
plot(t, Zdata(:, 2))
title('y(nTp)')
xlabel('t [s]')

%% Doświadczalny estymator transmitancji (wzór 15)
UN = fft(Zdata(:, 1));
YN = fft(Zdata(:, 2));

GN1 = YN ./ UN;
%% Doświadczalny estymator transmitancji (wzór 16)
Mw = 200;
tau = -Mw:Mw;
wH = 0.5*(1 + cos(tau*pi/Mw));

yu_corr = zeros(size(tau));
for i=1:length(tau)
    yu_corr(i) = Covar([Zdata(:, 2), Zdata(:, 1)], tau(i));
end

uu_corr = zeros(size(tau));
for i=1:length(tau)
    uu_corr(i) = Covar([Zdata(:, 1), Zdata(:, 1)], tau(i));
end

Phi_yu = zeros(1, N);
for k=0:N-1
    Phi_yu(k + 1) = Tp * sum(wH .* yu_corr .* exp(-1j .* tau .* (2*pi/N) * k));
end

Phi_uu = zeros(1, N);
for k=0:N-1
    Phi_uu(k + 1) = Tp * sum(wH .* uu_corr .* exp(-1j .* tau .* (2*pi/N) * k));
end

GN2 = Phi_yu ./ Phi_uu;
%% Wykresy Bodego
k = 0:(N-1)/2;
omega = 2*pi*k / (N * Tp);

figure
subplot(2, 1, 1)
semilogx(omega, 20*log10(abs(GN1(1:(N-1) / 2 + 1))))

subplot(2, 1, 2)
semilogx(omega, 20*log10(abs(GN2(1:(N-1) / 2 + 1))))
