close all;
clear;
clc;

output_dir = 'C:\Users\Mynam\Documents\Codex\2026-05-12\files-mentioned-by-the-user-lab1\lab1_delivery\figures';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

set(groot, 'defaultAxesFontName', 'Times New Roman');
set(groot, 'defaultTextFontName', 'Times New Roman');
set(groot, 'defaultAxesFontSize', 12);
set(groot, 'defaultTextFontSize', 12);
set(groot, 'defaultAxesLineWidth', 1.0);
set(groot, 'defaultLineLineWidth', 1.8);

clr_navy = [22, 74, 132] / 255;
clr_orange = [219, 120, 46] / 255;
clr_teal = [41, 136, 144] / 255;
clr_crimson = [170, 58, 77] / 255;
clr_gold = [196, 151, 58] / 255;
clr_slate = [88, 95, 108] / 255;
bg = [250, 250, 248] / 255;
grid_major = [190, 196, 204] / 255;
grid_minor = [222, 226, 231] / 255;
axis_col = [62, 68, 78] / 255;

dt = 0.2e-9;
t = 0:dt:0.1e-6;

f1 = 100e6;
f2 = 170e6;

S1 = cos(2*pi*f1*t);
S2 = cos(2*pi*f2*t);
S3 = S1 .* S2;

fig1 = figure('Color', bg, 'Position', [100 100 1080 820]);
tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;
plot(t * 1e9, S1, 'Color', clr_navy, 'LineWidth', 1.9);
hold on;
plot(t * 1e9, S1, 'Color', clr_navy, 'LineWidth', 5.0, 'Color', [clr_navy 0.08]);
xlabel('Time (ns)');
ylabel('Amplitude');
title('Input Signal S_1 = cos(2\pi f_1 t), f_1 = 100 MHz');
style_axes(gca, axis_col, grid_major, grid_minor, bg);
xlim([0 100]);
ylim([-1.15 1.15]);

nexttile;
plot(t * 1e9, S2, 'Color', clr_orange, 'LineWidth', 1.9);
hold on;
plot(t * 1e9, S2, 'Color', clr_orange, 'LineWidth', 5.0, 'Color', [clr_orange 0.08]);
xlabel('Time (ns)');
ylabel('Amplitude');
title('Input Signal S_2 = cos(2\pi f_2 t), f_2 = 170 MHz');
style_axes(gca, axis_col, grid_major, grid_minor, bg);
xlim([0 100]);
ylim([-1.15 1.15]);

nexttile;
plot(t * 1e9, S3, 'Color', clr_teal, 'LineWidth', 2.0);
hold on;
plot(t * 1e9, S3, 'Color', clr_teal, 'LineWidth', 5.4, 'Color', [clr_teal 0.08]);
xlabel('Time (ns)');
ylabel('Amplitude');
title('Mixer Output S_3 = S_1 \times S_2');
style_axes(gca, axis_col, grid_major, grid_minor, bg);
xlim([0 100]);
ylim([-1.15 1.15]);

sgtitle('Task 1: Time-Domain Signals', 'FontSize', 17, 'FontWeight', 'bold', 'Color', axis_col);
exportgraphics(fig1, fullfile(output_dir, 'task1_time_domain_signals.png'), 'Resolution', 300);

Fs = 1 / dt;
N = length(t);
freq_axis = (-floor(N/2):ceil(N/2)-1) * (Fs / N);

fft_S1 = fftshift(fft(S1));
fft_S2 = fftshift(fft(S2));
fft_S3 = fftshift(fft(S3));

mag_S1 = abs(fft_S1) / (N / 2);
mag_S2 = abs(fft_S2) / (N / 2);
mag_S3 = abs(fft_S3) / (N / 2);

fig2 = figure('Color', bg, 'Position', [100 100 1080 820]);
tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;
plot(freq_axis / 1e6, mag_S1, 'Color', clr_navy, 'LineWidth', 1.9);
xlabel('Frequency (MHz)');
ylabel('Magnitude');
title('Spectrum of S_1');
xlim([0 500]);
ylim([0 1.1]);
style_axes(gca, axis_col, grid_major, grid_minor, bg);

nexttile;
plot(freq_axis / 1e6, mag_S2, 'Color', clr_orange, 'LineWidth', 1.9);
xlabel('Frequency (MHz)');
ylabel('Magnitude');
title('Spectrum of S_2');
xlim([0 500]);
ylim([0 1.1]);
style_axes(gca, axis_col, grid_major, grid_minor, bg);

nexttile;
plot(freq_axis / 1e6, mag_S3, 'Color', clr_teal, 'LineWidth', 1.9);
xlabel('Frequency (MHz)');
ylabel('Magnitude');
title('Spectrum of S_3');
xlim([0 500]);
ylim([0 0.65]);
style_axes(gca, axis_col, grid_major, grid_minor, bg);

sgtitle('Task 2: Fourier Transform Magnitude Spectra', 'FontSize', 17, 'FontWeight', 'bold', 'Color', axis_col);
exportgraphics(fig2, fullfile(output_dir, 'task2_fft_subplots.png'), 'Resolution', 300);

single_plots = {
    'task2_s1_spectrum.png', mag_S1, 'Spectrum of S_1', clr_navy;
    'task2_s2_spectrum.png', mag_S2, 'Spectrum of S_2', clr_orange;
    'task2_s3_spectrum.png', mag_S3, 'Spectrum of S_3', clr_teal
};

for k = 1:size(single_plots, 1)
    fig = figure('Color', bg, 'Position', [100 100 820 540]);
    plot(freq_axis / 1e6, single_plots{k, 2}, 'Color', single_plots{k, 4}, 'LineWidth', 2.0);
    xlabel('Frequency (MHz)');
    ylabel('Magnitude');
    title(single_plots{k, 3});
    xlim([0 500]);
    style_axes(gca, axis_col, grid_major, grid_minor, bg);
    exportgraphics(fig, fullfile(output_dir, single_plots{k, 1}), 'Resolution', 300);
end

R = 50;
C = 25e-12;
L = 0.05e-6;
f = logspace(6, 9, 2000);
w = 2*pi*f;

H1 = 1 ./ (1 + 1j*w*R*C);
H2 = (1j*w*L) ./ (R + 1j*w*L);
H3 = (1j*w*L) ./ (R*(1 - w.^2*L*C) + 1j*w*L);

Amp_H1 = abs(H1);
Amp_H2 = abs(H2);
Amp_H3 = abs(H3);

dB_H1 = 20*log10(Amp_H1);
dB_H2 = 20*log10(Amp_H2);
dB_H3 = 20*log10(Amp_H3);

fig3 = figure('Color', bg, 'Position', [100 100 1040 800]);
tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;
semilogx(f / 1e6, Amp_H1, 'Color', clr_navy, 'LineWidth', 2.0);
xlabel('Frequency (MHz)');
ylabel('|H_1(f)|');
title('RC Low-Pass Filter');
style_axes(gca, axis_col, grid_major, grid_minor, bg);

nexttile;
semilogx(f / 1e6, Amp_H2, 'Color', clr_crimson, 'LineWidth', 2.0);
xlabel('Frequency (MHz)');
ylabel('|H_2(f)|');
title('RL High-Pass Filter');
style_axes(gca, axis_col, grid_major, grid_minor, bg);

nexttile;
semilogx(f / 1e6, Amp_H3, 'Color', clr_gold, 'LineWidth', 2.0);
xlabel('Frequency (MHz)');
ylabel('|H_3(f)|');
title('RLC Band-Pass Filter');
style_axes(gca, axis_col, grid_major, grid_minor, bg);

sgtitle('Task 3: Transfer Function Magnitude (Linear Scale)', 'FontSize', 17, 'FontWeight', 'bold', 'Color', axis_col);
exportgraphics(fig3, fullfile(output_dir, 'task3_linear_scale.png'), 'Resolution', 300);

fig4 = figure('Color', bg, 'Position', [100 100 1040 800]);
tiledlayout(3, 1, 'Padding', 'compact', 'TileSpacing', 'compact');

nexttile;
semilogx(f / 1e6, dB_H1, 'Color', clr_navy, 'LineWidth', 2.0);
xlabel('Frequency (MHz)');
ylabel('Magnitude (dB)');
title('RC Low-Pass Filter');
style_axes(gca, axis_col, grid_major, grid_minor, bg);

nexttile;
semilogx(f / 1e6, dB_H2, 'Color', clr_crimson, 'LineWidth', 2.0);
xlabel('Frequency (MHz)');
ylabel('Magnitude (dB)');
title('RL High-Pass Filter');
style_axes(gca, axis_col, grid_major, grid_minor, bg);

nexttile;
semilogx(f / 1e6, dB_H3, 'Color', clr_gold, 'LineWidth', 2.0);
xlabel('Frequency (MHz)');
ylabel('Magnitude (dB)');
title('RLC Band-Pass Filter');
style_axes(gca, axis_col, grid_major, grid_minor, bg);

sgtitle('Task 3: Transfer Function Magnitude (dB Scale)', 'FontSize', 17, 'FontWeight', 'bold', 'Color', axis_col);
exportgraphics(fig4, fullfile(output_dir, 'task3_db_scale.png'), 'Resolution', 300);

fc_rc = 1 / (2*pi*R*C);
fc_rl = R / (2*pi*L);
f0_rlc = 1 / (2*pi*sqrt(L*C));

mix_diff = abs(f2 - f1);
mix_sum = f1 + f2;

result_file = fullfile(output_dir, 'numeric_results.txt');
fid = fopen(result_file, 'w');
fprintf(fid, 'Sampling frequency (Hz): %.6e\n', Fs);
fprintf(fid, 'Mixer difference frequency (Hz): %.6e\n', mix_diff);
fprintf(fid, 'Mixer sum frequency (Hz): %.6e\n', mix_sum);
fprintf(fid, 'RC cutoff frequency (Hz): %.6e\n', fc_rc);
fprintf(fid, 'RL cutoff frequency (Hz): %.6e\n', fc_rl);
fprintf(fid, 'RLC resonant frequency (Hz): %.6e\n', f0_rlc);
fclose(fid);

save(fullfile(output_dir, 'workspace_results.mat'), ...
    'dt', 't', 'f1', 'f2', 'S1', 'S2', 'S3', ...
    'freq_axis', 'mag_S1', 'mag_S2', 'mag_S3', ...
    'f', 'Amp_H1', 'Amp_H2', 'Amp_H3', ...
    'dB_H1', 'dB_H2', 'dB_H3', ...
    'fc_rc', 'fc_rl', 'f0_rlc', 'mix_diff', 'mix_sum', 'Fs');

function style_axes(ax, axis_col, grid_major, grid_minor, bg)
    set(ax, ...
        'Box', 'off', ...
        'FontName', 'Times New Roman', ...
        'FontSize', 12, ...
        'LineWidth', 1.0, ...
        'XColor', axis_col, ...
        'YColor', axis_col, ...
        'Color', bg, ...
        'GridColor', grid_major, ...
        'GridAlpha', 0.35, ...
        'MinorGridColor', grid_minor, ...
        'MinorGridAlpha', 0.65, ...
        'TickDir', 'out');
    grid(ax, 'on');
    ax.XMinorGrid = 'on';
    ax.YMinorGrid = 'on';
end
