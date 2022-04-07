close all; clear; clc;

%% Wyświetlenie danych pomiarowych
load IdentWsadowaDyn.mat

Tp = 0.01;
n = 1:length(DaneDynC);
u = DaneDynC(n, 1);
y = DaneDynC(n, 2);

N = length(u);

%% Podział danych pomiarowych na 2 podzbiory
u_est = u(1:fix(N/2));
u_wer = u(fix(N/2)+1:end);

y_est = y(1:fix(N/2));
y_wer = y(fix(N/2)+1:end);

N_est = length(u_est);
N_wer = length(u_wer);
d = 2;

%% Identyfikacja - LS
Phi = zeros(N_est, d);
for k=2:N_est
    Phi(k, :) = [y_est(k-1), u_est(k-1)];
end

pLS = pinv(Phi) * y_est;

%% Identyfikacja - IV
Gq = tf(pLS(2), [1, -pLS(1)], Tp);
x = lsim(Gq, u_est, (0:N_est-1) * Tp);

Z = zeros(N_est, d);
for k=2:N_est
    Z(k, :) = [x(k-1), u_est(k-1)];
end

pIV = inv(Z' * Phi) * Z' * y_est;

T_hat = -Tp / log(pIV(1));
k_hat = pIV(2) / (1 - pIV(1));

%% Wykresy
G0 = tf(2.0, [0.5, 1]);
Gm = tf(k_hat, [T_hat, 1]);
t_wer = (0:N_wer-1) * Tp;

y0 = lsim(G0, u_wer, t_wer);
y_hat = zeros(N_wer, 1);
for k=2:N_wer
    y_hat(k) = pIV(1) * y_wer(k-1) + pIV(2) * u_wer(k-1);
end
ym = lsim(Gm, u_wer, t_wer);

figure
plot(t_wer, y_wer)
hold on
plot(t_wer, y0)
plot(t_wer, y_hat)
plot(t_wer, ym)
legend('zmierzona odpowiedź y(n)', 'odpowiedź niezakłócona systemu y_0(n)', 'odpowiedź predyktora jednokrokowego y(n|n-1)', 'odpowiedź modelu symulowanego y_m(n)')
grid on

%% Wskaźniki
V_p = 1/N_wer * sum((y_wer - y_hat).^2);
V_m = 1/N_wer * sum((y0 - ym).^2);
