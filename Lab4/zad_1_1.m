close all; clear; clc;

%% Zainicjowanie zmiennych globalnych
Tp = 0.1;
tend = 1000;
Td = 1500;
c1o = 0;

% Uruchomienie symulacji
sim('SystemARMAX');
