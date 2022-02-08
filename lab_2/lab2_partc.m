%% Read the bicep data
filtered = readtable("matthew_bicep1_filtered.csv");
raw = readtable("matthew_bicep1_raw.csv");
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

%% 4th order butterworth band pass filter
freqAxis = (0:length(raw.BICEP)-1) * 2000 / length(raw.BICEP);
raw_fft = fft(raw.BICEP);
figure(2)
plot(freqAxis, raw_fft)
xlim([0 1])
xlabel("Frequency (Hz)")
ylabel("Amplitude")
title("FFT of the raw signal (frequency over time)")

%% Original plots (for visualization purposes)

plot(raw.ElapsedTime, raw.BICEP)
plot(filtered.ElapsedTime, filtered.BICEP)