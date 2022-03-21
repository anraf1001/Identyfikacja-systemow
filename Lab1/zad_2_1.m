close all; clear; clc;

N = 2000;
Tp = 0.001;
sig = sqrt(1);

n = 0:N-1;
t = n*Tp;

x = sin(2*pi * 5*t) + 0.5 * sin(2*pi * 10*t) + 0.25 * sin(2*pi * 30*t);
e = sig * randn(1, N);
H = tf(0.1, [1 -0.9], Tp);
v = lsim(H, e, t)';

figure
subplot(3, 1, 1)
plot(t, x)
title('x(nTp)')

subplot(3, 1, 2)
plot(t, e)
title('e(nTp)')

subplot(3, 1, 3)
plot(t, v)
title('v(nTp)')

widm = 2 * abs(Tp * fft(x)) / (N * Tp);
f = (0:N-1) / (N * Tp);

figure
stem(f, widm)
title('Widmo amplitudowe')

Enc = Tp * sum(x.^2);
Enf = sum(Tp / N * abs(fft(x)).^2);

Phi = Tp / N * abs(fft(e)).^2;

Mw = 100;
tau = -Mw:Mw;
wP = ones(size(tau));
wH = 0.5*(1+cos(tau * pi / Mw));
e_corr = zeros(size(tau));
for k=1:length(tau)
    e_corr(k) = Covar([e', e'], tau(k));
end

PhiS = zeros(1, N);
for k=0:N-1
    PhiS(k + 1) = Tp * sum(wP .* e_corr .* exp(-1j .* tau .* (2*pi/N) * k));
end

figure
subplot(2, 1, 1)
plot(f, Phi)
title('Metoda periodogramowa - e(nTp)')

subplot(2, 1, 2)
plot(f, abs(PhiS))
title('Metoda korelogramowa - e(nTp)')

Phi_v = Tp / N * abs(fft(v)).^2;

v_corr = zeros(size(tau));
for k=1:length(tau)
    v_corr(k) = Covar([v', v'], tau(k));
end

PhiS_v = zeros(1, N);
for k=0:N-1
    PhiS_v(k + 1) = Tp * sum(wP .* v_corr .* exp(-1j .* tau .* (2*pi/N) * k));
end

figure
subplot(2, 1, 1)
plot(f, Phi_v)
title('Metoda periodogramowa - v(nTp)')

subplot(2, 1, 2)
plot(f, abs(PhiS_v))
title('Metoda korelogramowa - v(nTp)')
