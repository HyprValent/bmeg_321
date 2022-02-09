%% Read the bicep data
filtered = readtable("data\matthew_bicep1_filtered.csv");
raw = readtable("data\matthew_bicep1_raw.csv");
noise = raw;
noise.BICEP = noise.BICEP - filtered.BICEP;

filtered = removevars(filtered, "BioRadioEvent");
raw = removevars(raw, "BioRadioEvent");
noise = removevars(noise, "BioRadioEvent");

%% Find power spectrum of noisy signal
Fs = 2000;
SNR = snr(noise.BICEP,Fs);

figure(1)
snr(noise.BICEP,Fs);
xlim([0 0.4])

%% Noise power
[r, noisepow] = snr(raw.BICEP, noise.BICEP);
% noisepow will represent the noise power

%% FFT conversion
freqAxis = (0:length(raw.BICEP)-1) * 2000 / length(raw.BICEP);
raw_fft = fft(abs(raw.BICEP));
figure(2)
plot(freqAxis, real(raw_fft))
ylim([-0.7 0.7])
xlabel("Frequency (Hz)")
ylabel("Amplitude")
title("FFT of the raw signal (frequency over time)")

%% Creating the 4th order butterworth bpf
Fs = 2000;  % Sampling Frequency

N   = 4;    % Order
Fc1 = 50;  % First Cutoff Frequency
Fc2 = 185;  % Second Cutoff Frequency

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
Hd = design(h, 'butter');

filtered_raw = filter(Hd, raw.BICEP);

figure(3)
timeAxis = (0:length(filtered_raw)-1)*25/length(filtered_raw);
plot(timeAxis, filtered_raw)
xlabel("Time (s)");
ylabel("Amplitude");
title("Raw Signal after Band Pass Filter against Time")

%% Remove DC offset and perform a full-wave rectification
rectified = abs(filtered_raw - mean(filtered_raw));
figure(4)
plot(timeAxis, rectified);
ylim([0 0.003])
xlabel("Time (s)");
ylabel("Amplitude");
title("Rectified Filtered Signal against Time")

%% Testing different cut-off frequencies
Fc1_1 = 200;  % First Cutoff Frequency
Fc2_1 = 500;  % Second Cutoff Frequency
h_1  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1_1, Fc2_1, Fs);
Hd_1 = design(h_1, 'butter');
filtered_raw_1 = filter(Hd_1, raw.BICEP);
rectified_1 = abs(filtered_raw_1 - mean(filtered_raw_1));

figure(5)
plot(timeAxis, rectified_1)
ylim([0 0.0008])
xlabel("Time (s)");
ylabel("Amplitude");
title("Raw Signal after larger Band Pass Filter against Time")
SNR_1 = snr(rectified_1);

Fc1_1 = 10;  % First Cutoff Frequency
Fc2_1 = 100;  % Second Cutoff Frequency
h_1  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1_1, Fc2_1, Fs);
Hd_1 = design(h_1, 'butter');
filtered_raw_1 = filter(Hd_1, raw.BICEP);
rectified_1 = abs(filtered_raw_1 - mean(filtered_raw_1));

figure(6)
plot(timeAxis, rectified_1)
ylim([0 0.0035])
xlabel("Time (s)");
ylabel("Amplitude");
title("Raw Signal after smaller Band Pass Filter against Time")
SNR_2 = snr(rectified_1);

%% RMS envelope
[envelope_upper, envelope_lower] = envelope(filtered_raw, 300, 'rms');
figure(7)
plot(timeAxis, filtered_raw, 'color', 'red');
hold on
plot(timeAxis, envelope_upper, 'color', 'blue');
plot(timeAxis, envelope_lower, 'color', 'blue');
hold off
ylim([-0.003 0.003])
xlabel("Time (s)");
ylabel("Amplitude");
title("Filtered Raw signal with envelopes against time")

%% Integral
emg_integral = cumtrapz(timeAxis, filtered_raw);
figure(7)
plot(timeAxis, emg_integral)
% ylim([0 0.0035])
xlabel("Time (s)");
ylabel("Amplitude");
title("Cumulative Integral of Filtered Signal against Time")

emg_integral_scalar = trapz(timeAxis, filtered_raw);

%% EMG signal normalization
normalized = (envelope_upper/0.001)*100;
figure(7)
plot(timeAxis, normalized, 'color', 'red');
% ylim([0 0.0035])
xlabel("Time (s)");
ylabel("Amplitude");
title("Normalized envelope")

%% Original plots (for visualization purposes)

% plot(raw.ElapsedTime, raw.BICEP)
% plot(filtered.ElapsedTime, filtered.BICEP)