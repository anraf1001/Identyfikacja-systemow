close all; clear; clc;

%% Zainicjowanie zmiennych globalnych
Tp = 0.1;
tend = 1000;
Td = 1500;
c1o = 0.99;
t = 0:Tp:tend;

ident_select = 0; % 1 - RLS, 0 - RIV

%% Uruchomienie symulacji
sim('SystemARMAX');

%% Przebiegi estymat p
fig_p = figure;
subplot(3, 1, 1)
plot(a10)
title('Przebieg estymaty a_{10}')

subplot(3, 1, 2)
plot(a20)
title('Przebieg estymaty a_{20}')

subplot(3, 1, 3)
plot(b20)
title('Przebieg estymaty b_{20}')

%% Przebieg śladu macierzy P
fig_P = figure;
plot(Ptr)
title('Ślad macierzy P')

%% Porównanie odpowiedzi modelu symulowanego z odpowiedzią niezakłóconą
fig_m = figure;
plot(t, ym)
hold on
plot(t, yo)
legend('model symulowany', 'odpowiedź niezakłócona')
title('Porównanie odp. modelu symulowanego z odp. niezakłóconą')

%% Porównanie odpowiedzi predyktora jednokrokowego z odpowiedzią systemu
fig_pred = figure;
plot(t, y_hat)
hold on
plot(t, y)
legend('predyktor jednokrokowy', 'odpowiedź zakłócona')
title('Porównanie odp. predyktora jednokrokowego z odp. systemu')

%% Porównanie odpowiedzi modelu symulowanego z odpowiedzią systemu
fig_sys = figure;
plot(t, ym)
hold on
plot(t, y)
legend('model symulowany', 'odpowiedź systemu')
title('Porównanie odp. modelu symulowanego z odp. systemu')
