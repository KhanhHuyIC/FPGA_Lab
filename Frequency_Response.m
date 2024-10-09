% Parameters
file = 'ecg.hex';  % Hex file containing the data
fs = 400;  % Sampling frequency in Hz

% Read hex file and convert to signed decimal (24-bit)
fid = fopen(file, 'r');
hexData = textscan(fid, '%s');  % Read hex values as strings
fclose(fid);

% Convert hex strings to 24-bit signed integers
data = hex2dec(hexData{1});
data = data - (data >= 2^23) * 2^24;  % Convert to signed

% Time vector calculation
Samples = numel(data);
t = (0:Samples-1) / fs;  % Time vector in seconds

% Plot time-domain signal
figure;
subplot(2,1,1);
plot(t, data);
xlabel('Time (s)');
ylabel('Amplitude');
title('Time-Domain Signal');
grid on;

% Frequency domain analysis using FFT
Y = fft(data);  % Compute FFT
N = numel(data);
f = (0:N-1) * (fs/N) ;  % Frequency vector 

% Normalize and extract single-sided spectrum
magnitude = abs(Y)/N;
magnitude = magnitude(1:floor(N/2)+1);
magnitude(2:end-1) = 2 * magnitude(2:end-1);

% Plot frequency response
subplot(2,1,2);
plot(f(1:numel(magnitude)), magnitude);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Response');
grid on;
