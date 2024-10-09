
file = 'ecg.hex';  % Hex file containing the data
fs = 100e3;  % Sampling frequency in Hz

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

% Plot time-domain signal (original)
figure;
subplot(3, 1, 1);
plot(t, data);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Time-Domain Signal');
grid on;

% Apply the lowpass filter
Hd = sine_low();  % Call the lowpass filter function
filteredData = filter(Hd, data);  % Apply the filter to the data

% Plot filtered time-domain signal
subplot(3, 1, 2);
plot(t, filteredData);
xlabel('Time (s)');
ylabel('Amplitude');
title('Filtered Time-Domain Signal');
grid on;

% Frequency domain analysis of the original signal (FFT)
Y = fft(filteredData);  % Compute FFT of the filtered data
N = numel(filteredData);  % Number of samples
f = (0:N-1) * (fs/N) ;  % Frequency vector in MHz

% Normalize and extract single-sided spectrum
magnitude = abs(Y)/N;
magnitude = magnitude(1:floor(N/2)+1);
magnitude(2:end-1) = 2 * magnitude(2:end-1);

% Plot frequency response of the filtered signal
subplot(3, 1, 3);
plot(f(1:numel(magnitude)), magnitude);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Filtered Frequency Response');
grid on;

% Function: Lowpass filter design (provided in sine_low function)
function Hd = sine_low()
    % Equiripple Lowpass filter designed using the FIRPM function.
    Fs = 400;  % Sampling Frequency
    N     = 32;    % Filter Order
    Fpass = 1;   % Passband Frequency
    Fstop = 15;  % Stopband Frequency
    Wpass = 1;     % Passband Weight
    Wstop = 1;     % Stopband Weight
    dens  = 20;    % Density Factor

    % Calculate the coefficients using the FIRPM function.
    b  = firpm(N, [0 Fpass Fstop Fs/2]/(Fs/2), [1 1 0 0], [Wpass Wstop], {dens});
    Hd = dfilt.dffir(b);  % Create a digital filter object
end
