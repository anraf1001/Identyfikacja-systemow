close all; clear; clc;

%% Wczytanie danych pomiarowych
load IdentWsadowaDyn.mat

Tp = 0.01;
n = 1:length(DaneDynW);
u = DaneDynW(n, 1);
y = DaneDynW(n, 2);

N = length(u);

%% Podział danych pomiarowych na 2 podzbiory
u_est = u(1:fix(N/2));
u_wer = u(fix(N/2)+1:end);

y_est = y(1:fix(N/2));
y_wer = y(fix(N/2)+1:end);

N_est = length(u_est);
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
