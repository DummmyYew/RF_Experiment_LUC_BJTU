close all
clear all
clc

dt = 0.2e-9; 

t = 0 : dt : 0.1e-6;

f1 = 100e6; 
f2 = 170e6; 

S1 = cos(2 * pi * f1 * t);
S2 = cos(2 * pi * f2 * t);

S3 = S1 .* S2; 

figure; 

subplot(3, 1, 1);
plot(t, S1);
title('S1 = cos(2\pi f_1 t) [100 MHz]');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 1, 2);
plot(t, S2);
title('S2 = cos(2\pi f_2 t) [170 MHz]');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3, 1, 3);
plot(t, S3);
title('S3 = S1 \times S2 (Mixer Output)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

sgtitle('Mixer Signals - Task (1)');



