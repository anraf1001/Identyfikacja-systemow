close all; clear; clc;

load('ProcessStepResponse.mat');

k = 0.5;

ag = 0.03429;
tg = 8.6;
sg = 0.1551;

s = ag*S(:, 1) + sg - ag * tg;

figure;
plot(S(:, 1), S(:, 2));
hold on
plot(S(:, 1), s)
xlim([S(1, 1), S(end, 1)])
ylim([0, 0.5])
title('Process Step Response');
grid on

T0 = (ag*tg - sg) / ag;
T = k / ag;

Gm2 = tf(k, [T, 1], 'IODelay', T0);
[y_step, ~] = step(Gm2, S(:, 1));

figure;
hold on
plot(S(:, 1), S(:, 2));
plot(S(:, 1), y_step, '--');
hold off
title('Porównanie odpowiedzi skokowych')
legend('system', 'model')
grid on

[y_impulse, ~] = impulse(Gm2, S(:, 1));
y_impulse_sys = zeros(length(S), 1);
y_impulse_sys(1) = S(1, 2) / S(2, 1);
for k=2:length(S)
    y_impulse_sys(k) = (S(k, 2) - S(k-1, 2)) / (S(k, 1) - S(k-1, 1));
end

figure;
hold on
plot(S(:, 1), y_impulse_sys);
plot(S(:, 1), y_impulse, '--');
hold off
title('Porównanie odpowiedzi impulsowych')
legend('system', 'model')
grid on
