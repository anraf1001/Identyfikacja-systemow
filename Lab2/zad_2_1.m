close all; clear; clc;

Tp = 1;
sigma2v = 0;
N = 1001;
tend = N * Tp;

sim('AKident')

figure;
subplot(2, 1, 1)
plot(Zdata(:, 3), Zdata(:, 1))
title('u(nTp)')
grid on

subplot(2, 1, 2)
plot(Zdata(:, 3), Zdata(:, 2))
title('y(nTp)')
grid on

M = 30;
ryu = zeros(M, 1);
for tau=0:M-1
    ryu(tau + 1) = Covar([Zdata(:, 2), Zdata(:, 1)], tau);
end

Ruu = zeros(M, M);
for i=0:M-1
    for j=0:M-1
        Ruu(i+1, j+1) = Covar([Zdata(:, 1), Zdata(:, 1)], j - i);
    end
end

gM1 = 1 / Tp * pinv(Ruu) * ryu;
gM2 = 1 / Tp * ryu ./ Ruu(1, 1);
t = ((0:M-1) * Tp)';

figure
subplot(3, 1, 1)
plot(t, gM1)
title('Odpowiedź impulsowa - wzór 10')
grid on

subplot(3, 1, 2)
plot(t, gM2)
title('Odpowiedź impulsowa - wzór 11')
grid on

% G = tf(2, [1 -0.7], Tp);
% [yimp, ~] = impulse(G, 1:M);
G = tf(0.5, [5 11 7 1], 'IODelay', 3);
[yimp, ~] = impulse(G, t);
subplot(3, 1, 3)
plot(t, yimp)
title('Odpowiedź impulsowa - teoretyczna')
grid on

hM1 = cumsum(gM1);
hM2 = cumsum(gM2);

figure
subplot(2, 1, 1)
plot(t, hM1)
title('Odpowiedź skokowa - wzór 10')
grid on

subplot(2, 1, 2)
plot(t, hM2)
title('Odpowiedź skokowa - wzór 11')
grid on
