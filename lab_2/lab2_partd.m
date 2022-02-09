%% Data imported from matlab_matthew.mat in /data directory
raw = BioRadioData{1, 1}{1, 1};
timeAxis = (0:length(raw)-1)*30/length(raw);
plot(timeAxis, raw)
xlabel("Time (s)");
ylabel("Amplitude");
title("Raw Signal before Processing against Time")

%% FFT conversion
freqAxis = (0:length(raw)-1) * 2000 / length(raw);
raw_fft = fft(abs(raw));
figure(2)
plot(freqAxis, real(raw_fft))
ylim([-0.7 0.7])
xlabel("Frequency (Hz)")
ylabel("Amplitude")
title("FFT of the raw signal (frequency over time)")

%% Creating the 4th order butterworth bpf
Fs = 2000;  % Sampling Frequency

N   = 4;    % Order
Fc1 = 34;  % First Cutoff Frequency
Fc2 = 166;  % Second Cutoff Frequency

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
Hd = design(h, 'butter');

filtered_raw = filter(Hd, raw);

figure(3)
timeAxis = (0:length(filtered_raw)-1)*30/length(filtered_raw);
plot(timeAxis, filtered_raw)
xlabel("Time (s)");
ylabel("Amplitude");
title("Raw Signal after Band Pass Filter against Time")

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

%% EMG signal normalization
normalized = (envelope_upper/0.001)*100;
figure(7)
plot(timeAxis, normalized, 'color', 'red');
% ylim([0 0.0035])
xlabel("Time (s)");
ylabel("Amplitude");
title("Raw Signal after Processing against Time")

