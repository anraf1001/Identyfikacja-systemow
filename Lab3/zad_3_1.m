close all; clear; clc;

%% Wczytanie danych pomiarowych
load IdentWsadowaDyn.mat

Tp = 0.01;
n = 1:length(DaneDynW);
u = DaneDynW(n, 1);
y = DaneDynW(n, 2);

N = length(u);

%% Podział danych pomiarowych na 2 podzbiory
N_est = fix(N/2);
u_est = u(1:N_est);
u_wer = u(N_est+1:end);

y_est = y(1:N_est);
y_wer = y(N_est+1:end);

N_wer = length(u_wer);
d = 2;

%% Filtracja SVF
s = tf('s');
TF = 50 * Tp;
t_est = (0:N_est-1) * Tp;
n = 1;

F0 = 1 / (1 + TF * s) ^ n;
F1 = s / (1 + TF * s) ^ n;

yF = lsim(F0, y_est, t_est, 'foh');
ypF = lsim(F1, y_est, t_est, 'foh');
uF = lsim(F0, u_est, t_est, 'foh');

%% Identyfikacja
Phi = [yF, uF];
pLS = pinv(Phi) * ypF;
T0 = -1/pLS(1);
k0 = T0 * pLS(2);

%% Wykresy
G0 = tf(2.0, [0.5, 1]);
Gm = tf(k0, [T0, 1]);
t_wer = (0:N_wer-1) * Tp;

y0 = lsim(G0, u_wer, t_wer);
ym = lsim(Gm, u_wer, t_wer);

figure
hold on
plot(t_wer, y0)
plot(t_wer, ym)
legend('odpowiedź niezakłócona systemu y_0(n)', 'odpowiedź modelu symulowanego y_m(n)')
grid on
