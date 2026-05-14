% ==========================================
% Task (3): Transfer Functions Plotting (Separate Plots)
% ==========================================

% 1. 定义电路参数
R = 50;           % 电阻 R = 50 Ohms
C = 25e-12;       % 电容 C = 25 pF
L = 0.05e-6;      % 电感 L = 0.05 uH

% 2. 定义频率范围 (1 MHz 到 1 GHz)
f = logspace(6, 9, 2000); 
w = 2 * pi * f;   

% 3. 计算三个传递函数 (复数形式)
H1 = 1 ./ (1 + 1j * w * R * C);                                 
H2 = (1j * w * L) ./ (R + 1j * w * L);                          
H3 = (1j * w * L) ./ (R .* (1 - w.^2 * L * C) + 1j * w * L);    

% 计算 Amplitude (取绝对值)
Amp_H1 = abs(H1);
Amp_H2 = abs(H2);
Amp_H3 = abs(H3);

% 计算 dB 刻度
dB_H1 = 20 * log10(Amp_H1);
dB_H2 = 20 * log10(Amp_H2);
dB_H3 = 20 * log10(Amp_H3);

% ==========================================
% 4. 绘制图表 1：线性刻度幅度图 (Linear Scale)
figure(1);
sgtitle('Transfer Functions Amplitude (Linear Scale)', 'FontSize', 14, 'FontWeight', 'bold');

% RC Low-Pass
subplot(3, 1, 1);
semilogx(f/1e6, Amp_H1, 'b', 'LineWidth', 1.5);
grid on;
title('Circuit 1: RC Low-Pass');
ylabel('Linear Amp');

% RL High-Pass
subplot(3, 1, 2);
semilogx(f/1e6, Amp_H2, 'b', 'LineWidth', 1.5);
grid on;
title('Circuit 2: RL High-Pass');
ylabel('Linear Amp');

% RLC Band-Pass
subplot(3, 1, 3);
semilogx(f/1e6, Amp_H3, 'b', 'LineWidth', 1.5);
grid on;
title('Circuit 3: RLC Band-Pass');
xlabel('Frequency (MHz)');
ylabel('Linear Amp');

% ==========================================
% 5. 绘制图表 2：dB 刻度幅度图 (dB Scale)
figure(2);
sgtitle('Transfer Functions Amplitude (dB Scale)', 'FontSize', 14, 'FontWeight', 'bold');

% RC Low-Pass
subplot(3, 1, 1);
semilogx(f/1e6, dB_H1, 'b', 'LineWidth', 1.5);
grid on;
title('Circuit 1: RC Low-Pass');
ylabel('Amplitude (dB)');

% RL High-Pass
subplot(3, 1, 2);
semilogx(f/1e6, dB_H2, 'b', 'LineWidth', 1.5);
grid on;
title('Circuit 2: RL High-Pass');
ylabel('Amplitude (dB)');

% RLC Band-Pass
subplot(3, 1, 3);
semilogx(f/1e6, dB_H3, 'b', 'LineWidth', 1.5);
grid on;
title('Circuit 3: RLC Band-Pass');
xlabel('Frequency (MHz)');
ylabel('Amplitude (dB)');