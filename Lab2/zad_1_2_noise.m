close all; clear; clc;

load('NoisyProcessStepResponse.mat');

k = 0.24;

ag = 0.0065;
tg = 23.7;
sg = 0.05615;

s = ag*nS(:, 1) + sg - ag * tg;

figure;
plot(nS(:, 1), nS(:, 2));
hold on
plot(nS(:, 1), s)
xlim([nS(1, 1), nS(end, 1)])
ylim([0, 0.25])
title('Noisy Process Step Response');
grid on

T0 = (ag*tg - sg) / ag;
T = k / ag;

T0 = (ag*tg - sg) / ag;
T = k / ag;

Gm2 = tf(k, [T, 1], 'IODelay', T0);
[y_step, ~] = step(Gm2, nS(:, 1));

figure;
hold on
plot(nS(:, 1), nS(:, 2));
plot(nS(:, 1), y_step, '--');
hold off
title('Porównanie odpowiedzi skokowych')
legend('system', 'model')
grid on
