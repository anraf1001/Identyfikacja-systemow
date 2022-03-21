close all; clear; clc;

load('StochasticProcess.mat')

hold on
plot(StochasticProcess(1,:), StochasticProcess(2,:))
plot(StochasticProcess(1,:), StochasticProcess(3,:))
plot(StochasticProcess(1,:), StochasticProcess(4,:))
hold off

Mi = mean(StochasticProcess(2:end, :));
M = mean(StochasticProcess(2:end, :), 2);

figure;
plot(M')
hold on
plot(Mi)
hold off

mi = mean(Mi);
m = mean(M);

Sig2_i = var(StochasticProcess(2:end, :), 1);
Sig2 = var(StochasticProcess(2:end, :), 1, 2);

figure;
plot(Sig2')
hold on
plot(Sig2_i)
hold off

sig2_i = mean(Sig2_i);
sig2 = mean(Sig2);
