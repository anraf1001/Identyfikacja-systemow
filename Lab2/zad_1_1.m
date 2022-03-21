close all; clear; clc;

load('ProcessStepResponse.mat');

figure;
plot(S(:, 1), S(:, 2));
title('Process Step Response');
grid on

k = 0.5;
T50 = 11.5;
T90 = 22.7;
disp('T90 / T50:')
disp(T90 / T50)

p = 3;
T = T90 / 5.32;

s = tf('s');
Gm1 = k / (T*s+1)^p;

[y_step, ~] = step(Gm1, S(:, 1));

figure;
hold on
plot(S(:, 1), S(:, 2));
plot(S(:, 1), y_step, '--');
hold off
title('Porównanie odpowiedzi skokowych')
legend('system', 'model')
grid on

[y_impulse, ~] = impulse(Gm1, S(:, 1));
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
