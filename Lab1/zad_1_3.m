close all; clear; clc;

sig = sqrt(1);
N = 2000;
Tp = 0.001;

n = 0:N-1;
tn = n * Tp;

e = sig * randn(1, N);
x = sin(2 * pi * 5 * tn);
y = sin(2 * pi * 5 * tn) + e(n + 1);
H = tf(0.1, [1 -0.9], Tp);
v = lsim(H, e, tn)';

figure;
subplot(4, 1, 1)
plot(tn, e)
title('e(nTp)')
subplot(4, 1, 2)
plot(tn, x)
title('x(nTp)')
subplot(4, 1, 3)
plot(tn, y)
title('y(nTp)')
subplot(4, 1, 4)
plot(tn, v)
title('v(nTp)')

e_corr = zeros(1, N);
for k=0:N-1
    e_corr(k+1) = Covar([e', e'], k);
end

x_corr = zeros(1, N);
for k=0:N-1
    x_corr(k+1) = Covar([x', x'], k);
end

y_corr = zeros(1, N);
for k=0:N-1
    y_corr(k+1) = Covar([y', y'], k);
end

v_corr = zeros(1, N);
for k=0:N-1
    v_corr(k+1) = Covar([v', v'], k);
end

e_corr_flip = flip(e_corr);
e_corr = [e_corr_flip, e_corr(2:end)];

x_corr_flip = flip(x_corr);
x_corr = [x_corr_flip, x_corr(2:end)];

y_corr_flip = flip(y_corr);
y_corr = [y_corr_flip, y_corr(2:end)];

v_corr_flip = flip(v_corr);
v_corr = [v_corr_flip, v_corr(2:end)];

figure;
subplot(4, 1, 1)
plot(-(N-1):N-1, e_corr)
title('e corr')
subplot(4, 1, 2)
plot(-(N-1):N-1, x_corr)
title('x corr')
subplot(4, 1, 3)
plot(-(N-1):N-1, y_corr)
title('y corr')
subplot(4, 1, 4)
plot(-(N-1):N-1, v_corr)
title('v corr')

yx_corr = zeros(1, N);
for k=0:N-1
    yx_corr(k+1) = Covar([y', x'], k);
end

xy_corr = zeros(1, N);
for k=0:N-1
    xy_corr(k+1) = Covar([x', y'], k);
end

figure;
plot(-(N-1):N-1, [flip(xy_corr), yx_corr(2:end)])
title('yx corr')
