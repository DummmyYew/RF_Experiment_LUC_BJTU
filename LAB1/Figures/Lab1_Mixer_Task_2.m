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




% ==========================================
% Task: Fourier Transform of the three signals
% ==========================================


time_between_samples = (t(end)-t(1))/length(t); 
sampling_frequency = 1/time_between_samples;

x1 = -floor(length(t)/2) : floor(length(t)/2);
df1 = sampling_frequency / length(x1);


freq_axis_MHz = x1 * df1 ./ 1e6;


fft_S1 = fft(S1);
fft_S2 = fft(S2);
fft_S3 = fft(S3);


EV_S1 = fftshift(abs(fft_S1)) ./ (length(x1)/2);
EV_S2 = fftshift(abs(fft_S2)) ./ (length(x1)/2);
EV_S3 = fftshift(abs(fft_S3)) ./ (length(x1)/2);


figure(8); 


subplot(3, 1, 1);
plot(freq_axis_MHz, EV_S1, 'LineWidth', 1.5);
set(gca, 'fontsize', 14);
grid on; 
xlabel('Frequency (MHz)');
ylabel('Magnitude');
title('Spectrum of S1 (100 MHz)');
axis([0 500 0 1.2]); 


subplot(3, 1, 2);
plot(freq_axis_MHz, EV_S2, 'LineWidth', 1.5);
set(gca, 'fontsize', 14);
grid on; 
xlabel('Frequency (MHz)');
ylabel('Magnitude');
title('Spectrum of S2 (170 MHz)');
axis([0 500 0 1.2]);


subplot(3, 1, 3);
plot(freq_axis_MHz, EV_S3, 'LineWidth', 1.5);
set(gca, 'fontsize', 14);
grid on; 
xlabel('Frequency (MHz)');
ylabel('Magnitude');
title('Spectrum of S3 (Mixer Output)');
axis([0 500 0 1.2]);
