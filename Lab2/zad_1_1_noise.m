close all; clear; clc;

load('NoisyProcessStepResponse.mat');

figure;
plot(nS(:, 1), nS(:, 2));
title('Noisy Process Step Response');
grid on

k = 0.24;
T50 = 33.2;
T90 = 57.1;
disp('T90 / T50:')
disp(T90 / T50)

p = 5;
T = T90 /  7.99;

s = tf('s');
Gm1 = k / (T*s+1)^p;

[y_step, ~] = step(Gm1, nS(:, 1));

figure;
hold on
plot(nS(:, 1), nS(:, 2));
plot(nS(:, 1), y_step, '--');
hold off
title('Porównanie odpowiedzi skokowych')
legend('system', 'model')
grid on

[y_impulse, ~] = impulse(Gm1, nS(:, 1));
y_impulse_sys = zeros(length(nS), 1);
y_impulse_sys(1) = nS(1, 2) / nS(2, 1);
for k=2:length(nS)
    y_impulse_sys(k) = (nS(k, 2) - nS(k-1, 2)) / (nS(k, 1) - nS(k-1, 1));
end

figure;
hold on
plot(nS(:, 1), y_impulse_sys);
plot(nS(:, 1), y_impulse, '--');
hold off
title('Porównanie odpowiedzi impulsowych')
legend('system', 'model')
grid on
