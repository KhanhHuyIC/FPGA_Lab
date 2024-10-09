% read file
[file, fs] = audioread('C:\MATLAB\FPGA\ecg_trans.wav');

% Tinh so diem du lieu
N = length(file); % S? ?i?m d? li?u
frequencies = (0:N-1)*(fs/N); % Tr?c t?n s?

% chuyen doi thanh mien tan so
X = fft(file);

% Loc bo nhieu co tan so thap hon 7900 Hz
cutoff_freq = 400; 
filter = frequencies <= cutoff_freq; 
% Tach tin hieu va nhieu
signal_fft = X .* filter'; 
noise_fft = X .* (~filter)'; 

% Tinh cong suat tin hieu va nhieu
signal_power = sum(abs(signal_fft).^2) / N; %
noise_power = sum(abs(noise_fft).^2) / N; 

% tinh SNR
SNR = 10 * log10(signal_power / noise_power);

% Hi?n th? k?t qu?
disp(['SNR = ', num2str(SNR), ' dB']);
