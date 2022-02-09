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
Fc2 = 150;  % Second Cutoff Frequency

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
Hd = design(h, 'butter');

filtered_raw = filter(Hd, raw.BICEP);

figure(4)
timeAxis = (0:length(Hd)-1)*30/length(Hd);
plot(timeAxis, filtered_raw)
xlabel("Time (s)");
ylabel("Amplitude");
title("Raw Signal after Band Pass Filter against Time")

%% Original plots (for visualization purposes)

plot(raw.ElapsedTime, raw.BICEP)
plot(filtered.ElapsedTime, filtered.BICEP)